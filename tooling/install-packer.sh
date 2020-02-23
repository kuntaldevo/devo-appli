#!/usr/bin/env bash

# PACKER INSTALLER - Automated Packer Installation
#   Apache 2 License - Copyright (c) 2018  Robert Peteuil  @RobertPeteuil
#
#     Automatically Download, Extract and Install
#        Latest or Specific Version of Packer
#
#   from: https://github.com/robertpeteuil/packer-installer

# Uncomment line below to always use 'sudo' to install to /usr/local/bin/
# sudoInstall=true

scriptname=$(basename "$0")
scriptbuildnum="1.3.0"
scriptbuilddate="2018-05-13"


# CHECK DEPENDANCIES AND SET NET RETRIEVAL TOOL
if ! unzip -h 2&> /dev/null; then
  echo "aborting - unzip not installed and required"
  exit 1
fi

if curl -h 2&> /dev/null; then
  nettool="curl"
elif wget -h 2&> /dev/null; then
  nettool="wget"
else
  echo "aborting - wget or curl not installed and required"
  exit 1
fi

if jq --help 2&> /dev/null; then
  nettool="${nettool}jq"
fi

# USE NET RETRIEVAL TOOL TO GET LATEST VERSION
case "${nettool}" in
  # jq installed - parse version from hashicorp website
  wgetjq)
    LATEST=$(wget -q -O- https://releases.hashicorp.com/index.json 2>/dev/null | jq -r '.packer.versions[].version' | sort --version-sort -r | head -n 1)
    ;;
  curljq)
    LATEST=$(curl -s https://releases.hashicorp.com/index.json 2>/dev/null | jq -r '.packer.versions[].version' | sort --version-sort -r | head -n 1)
    ;;
  # parse version from github API - use Tags for Packer as release not populated
  wget)
    LATEST=$(wget -q -O- https://api.github.com/repos/hashicorp/packer/tags 2>/dev/null | grep name | sort --version-sort -r | head -n 1 | awk '{print $2}' | cut -d '"' -f 2 | cut -d 'v' -f 2)
    ;;
  curl)
    LATEST=$(curl -s https://api.github.com/repos/hashicorp/packer/tags 2>/dev/null | grep name | sort --version-sort -r | head -n 1 | awk '{print $2}' | cut -d '"' -f 2 | cut -d 'v' -f 2)
    ;;
esac

displayVer() {
  echo -e "${scriptname}  ver ${scriptbuildnum} - ${scriptbuilddate}"
}

usage() {
  [[ "$1" ]] && echo -e "Download and Install Packer - Latest Version unless '-i' specified\n"
  echo -e "usage: ${scriptname} [-i VERSION] [-h] [-v]"
  echo -e "     -i VERSION\t: specify version to install in format '$LATEST' (OPTIONAL)"
  echo -e "     -a\t\t: automatically use sudo to install to /usr/local/bin"
  echo -e "     -h\t\t: help"
  echo -e "     -v\t\t: display ${scriptname} version"
}

while getopts ":i:ahv" arg; do
  case "${arg}" in
    a)  sudoInstall=true;;
    i)  VERSION=${OPTARG};;
    h)  usage x; exit;;
    v)  displayVer; exit;;
    \?) echo -e "Error - Invalid option: $OPTARG"; usage; exit;;
    :)  echo "Error - $OPTARG requires an argument"; usage; exit 1;;
  esac
done
shift $((OPTIND-1))

# POPULATE VARIABLES NEEDED TO CREATE DOWNLOAD URL AND FILENAME
if [[ -z "$VERSION" ]]; then
  VERSION=$LATEST
fi
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "$OS" == "linux" ]]; then
  PROC=$(lscpu 2> /dev/null | awk '/Architecture/ {if($2 == "x86_64") {print "amd64"; exit} else {print "386"; exit}}')
  if [[ -z $PROC ]]; then
    PROC=$(cat /proc/cpuinfo | awk '/flags/ {if($0 ~ /lm/) {print "arm64"; exit} else {print "386"; exit}}')
  fi
else
  PROC="amd64"
fi
[[ $PROC =~ arm ]] && PROC="arm"  # Packer downloads use "arm" not full arm type

# CREATE FILENAME AND DOWNLOAD LINK BASED ON GATHERED PARAMETERS
FILENAME="packer_${VERSION}_${OS}_${PROC}.zip"
LINK="https://releases.hashicorp.com/packer/${VERSION}/${FILENAME}"
case "${nettool}" in
  wget*)
    LINKVALID=$(wget --spider -S "$LINK" 2>&1 | grep "HTTP/" | awk '{print $2}') ;;
  curl*)
    LINKVALID=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' "$LINK") ;;
esac

# VERIFY LINK VALIDITY
if [[ "$LINKVALID" != 200 ]]; then
  echo -e "Cannot Install - Download URL Invalid"
  echo -e "\nParameters:"
  echo -e "\tVER:\t$VERSION"
  echo -e "\tOS:\t$OS"
  echo -e "\tPROC:\t$PROC"
  echo -e "\tURL:\t$LINK"
  exit 1
fi

# DETERMINE DESTINATION
if [[ -w "/usr/local/bin" ]]; then
  BINDIR="/usr/local/bin"
  CMDPREFIX=""
  STREAMLINED=true
elif [[ "$sudoInstall" ]]; then
  BINDIR="/usr/local/bin"
  CMDPREFIX="sudo "
  STREAMLINED=true
else
  echo -e "Packer Installer\n"
  echo "Specify install directory (a,b or c):"
  echo -en "\t(a) '~/bin'    (b) '/usr/local/bin' as root    (c) abort : "
  read -r -n 1 SELECTION
  echo
  if [ "${SELECTION}" == "a" ] || [ "${SELECTION}" == "A" ]; then
    BINDIR="${HOME}/bin"
    CMDPREFIX=""
  elif [ "${SELECTION}" == "b" ] || [ "${SELECTION}" == "B" ]; then
    BINDIR="/usr/local/bin"
    CMDPREFIX="sudo "
  else
    exit 0
  fi
fi

# CREATE TMPDIR FOR EXTRACTION
TMPDIR=${TMPDIR:-/tmp}
UTILTMPDIR="packer_${VERSION}"

cd "$TMPDIR" || exit 1
mkdir -p "$UTILTMPDIR"
cd "$UTILTMPDIR" || exit 1

# DOWNLOAD AND EXTRACT
case "${nettool}" in
  wget*)
    wget -q "$LINK" -O "$FILENAME" ;;
  curl*)
    curl -s -o "$FILENAME" "$LINK" ;;
esac
unzip -qq "$FILENAME" || exit 1

# COPY TO DESTINATION
mkdir -p "${BINDIR}" || exit 1
${CMDPREFIX} cp -f packer "$BINDIR" || exit 1

# CLEANUP AND EXIT
cd "${TMPDIR}" || exit 1
rm -rf "${UTILTMPDIR}"
[[ ! "$STREAMLINED" ]] && echo
echo "Packer Version ${VERSION} installed to ${BINDIR}"

exit 0
