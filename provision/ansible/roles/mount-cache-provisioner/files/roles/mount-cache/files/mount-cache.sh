

#Start Time
start_time=`date +%s`

echo "Start Time: `date`"


# If on an older system that is using EBS volumes for cache, then we will assume that there might be an array of volume names passed in.
# If any params that are passed in then we will assume we will only mount those volumes and assume they are there.
# If there are enough disks then the cache will be a RAID

ephemerals="$@"

#Find any attached ephemeral drives and turn into a raid
#if you want to see the log output...  cat /var/log/cloud-init-output.log

RAID_MOUNT_POINT="/mnt/cache"

# Create Cache location
mkdir -p $RAID_MOUNT_POINT

# With Ansible I added this installation to the parent's dependencies
#yum -y -d0 install mdadm curl

function use_lsblk {

  ###Figure out if we have LSBLK
  which lsblk
  has_lsblk=`echo $?`

  if [[ $has_lsblk != 0 ]]; then
    echo "Error need LSBLK ."
    exit 22
  fi

  # Get the name of the root device
  # If this is an ssd ( and maybe others ) there might be a partition # attached
  # This will start with a /dev
  root_drive=`mount | grep ' / ' | cut -d' ' -f 1`

  echo "Determined the root drive is $root_drive and will be excluded."

  # Run the found root_drive through to remove any partitition data
  # This will strip off any prefixes like /dev
  root_drive=` lsblk -no pkname $root_drive `

  ephemerals=$( lsblk --output name --nodeps --noheadings | grep -v $root_drive | sort )
}


if [[ -z $ephemerals ]]; then
  use_lsblk
else
  echo "Found Volume Names ( $ephemerals ) passed in. Using only those"
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
    echo "Mounting drive ($device_name) to $RAID_MOUNT_POINT"
    mount -t ext4 -o noatime $device_name $RAID_MOUNT_POINT

  elif [[ "$ephemeral_count" == 1 ]]; then
    device_name=$drives
    sudo mkfs -t ext4 $drives
    echo "Mounting drives ($drives) to $RAID_MOUNT_POINT"
    mount -t ext4 -o noatime $drives $RAID_MOUNT_POINT
  fi

  chmod -R 777 $RAID_MOUNT_POINT
  touch $RAID_MOUNT_POINT/MOUNTED.txt

  # Make raid appear on reboot
  echo "$device_name $RAID_MOUNT_POINT ext4 noatime 0 0" | tee -a /etc/fstab

  echo "Validate RAID, /etc/mdadm.conf"
  cat /etc/mdadm.conf
  echo "Validate RAID, /proc/mdstat"
  cat /proc/mdstat
fi

end_time=`date +%s`

let deltatime=end_time-start_time
let minutes=(deltatime/60)%60
let seconds=deltatime%60

echo "End Time: `date`"
printf "Time spent: %02d:%02d\n" $minutes $seconds
