### Find any attached ephemeral drives and turn into a raid
#if you want to see the log output...  cat /var/log/cloud-init-output.log

RAID_MOUNT_POINT="/mnt/cache"

# Create future Cache location
mkdir -p $RAID_MOUNT_POINT

METADATA_URL_BASE="http://169.254.169.254/latest"

yum -y -d0 install mdadm curl


###Figure out if we have LSBLK
which lsblk
has_lsblk=`echo $?`


# Get the name of the root device
# If this is an ssd ( and maybe others ) there might be a partition # attached
# This will start with a /dev
root_drive=`mount | grep ' / ' | cut -d' ' -f 1`

function use_lsblk {

  # Run the found root_drive through to remove any partitition data
  # This will strip off any prefixes like /dev
  root_drive=` lsblk -no pkname $root_drive `

  ephemerals=$( lsblk --output name --nodeps --noheadings | grep -v $root_drive | sort )
}


if [[ $has_lsblk == 0 ]]; then
  use_lsblk
else
  echo "Error need LSBLK ."
fi

ephemeral_count=0

for e in $ephemerals; do

    device_path="/dev/$e"

  # test that the device actually exists since you can request more ephemeral drives than are available
  # for an instance type and the meta-data API will happily tell you it exists when it really does not.
  if [ -b $device_path ]; then
    echo "Detected ephemeral disk: $device_path"
    drives="$drives $device_path"
    ephemeral_count=$((ephemeral_count + 1 ))
  else
    echo "Ephemeral disk $e, $device_path is not present. skipping"
  fi
done

if [ "$ephemeral_count" = 0 ]; then
  echo "No ephemeral disk detected."
else
#I had thrown an exit condition in here for when ephemeral count is zero but then the rest of the script ends.
  # overwrite first few blocks in case there is a filesystem, otherwise mdadm will prompt for input
  for drive in $drives; do
    dd if=/dev/zero of=$drive bs=4096 count=1024
  done

  device_name="/dev/md0"

  if [[ "$ephemeral_count" > 1 ]]; then

    mdadm --create --verbose --force $device_name --level=raid0 -c256 --raid-devices=$ephemeral_count $drives
    echo DEVICE $drives | tee /etc/mdadm.conf
    mdadm --detail --scan | tee -a /etc/mdadm.conf
    blockdev --setra 65536 $device_name
    mkfs -t ext4 $device_name
    mount -t ext4 -o noatime $device_name $RAID_MOUNT_POINT

  elif [[ "$ephemeral_count" == 1 ]]; then
    device_name=$drives
    sudo mkfs -t ext4 $drives
    mount -t ext4 -o noatime $drives $RAID_MOUNT_POINT
  fi

  # Make raid appear on reboot
  echo "$device_name $RAID_MOUNT_POINT ext4 noatime 0 0" | tee -a /etc/fstab

  echo "Validate RAID, /etc/mdadm.conf"
  cat /etc/mdadm.conf
  echo "Validate RAID, /proc/mdstat"
  cat /proc/mdstat
fi
