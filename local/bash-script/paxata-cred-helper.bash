
###
### Helper functions
###

### Validate PAX_USER set

function __pax_user-set {

  if [  -z $PAX_USER ]; then
     echo "Please set environment variable, PAX_USER, in your .bashrc "
     return 1
  fi

}


###
### Validate tools are installed
###

function __oathtool-installed {

  command -v oathtool
  if [[ $? -ne 0 ]]; then
     echo "Oathtool not found. Install via: brew install oath-toolkit"
     return 1
  fi

}

function __openvpn-installed {

  command -v $(brew --prefix openvpn)/sbin/openvpn
  if [ $? -ne 0 ]; then
     echo "OpenVPN not found. Install via: brew install openvpn"
     return 1
  fi

}

####
####
####


function jump () {

  local MFA_FILE="$HOME/.ssh/jumpcloud-user.mfa"
  if [ ! -f $MFA_FILE ]; then
     echo "Required file does not exist: $MFA_FILE"
     return 1
  fi

  __oathtool-installed
  if [[ $? -ne 0 ]]; then return $?; fi

  __pax_user-set
  if [[ "$?" -ne 0 ]]; then return $?; fi

  SECRET="$(cat ${MFA_FILE})"
  echo -e "${RED} $(oathtool --base32 --totp $SECRET) ${NC}"

  ssh $PAX_USER@prod-jumphost01.paxata.com
}


function aws-auth () {

  local MFA_FILE="$HOME/.ssh/jumpcloud-user.mfa"
  if [ ! -f $MFA_FILE ]; then
     echo "Required file does not exist: $MFA_FILE"
     return 1
  fi

  __oathtool-installed
  if [[ $? -ne 0 ]]; then return $?; fi

  SECRET="$(cat ${MFA_FILE})"
  TOKEN="$(oathtool --base32 --totp $SECRET)"
  echo -e "${RED} $TOKEN ${NC}"

  saml2aws login --skip-prompt --force --mfa-token=$TOKEN
}

function openvpn () {

  __openvpn-installed

  ###  Add debug if passed in
  # OPVN_DEBUG="--verb 3"
  OPVN_DEBUG="--verb 0"

  SECRET="$(cat ~/.openvpn.mfa)"
  TOKEN="$(oathtool --base32 --totp $SECRET)"
  echo -e "${RED} $TOKEN ${NC}"

  sudo $(brew --prefix openvpn)/sbin/openvpn --config ~/.openvpn.ovpn --auth-user-pass ~/.openvpn.creds $OPVN_DEBUG

}
