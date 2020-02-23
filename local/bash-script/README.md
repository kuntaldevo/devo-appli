
Add the following to your bashrc to get these extensions.

For Datarobot setup. create a username file in `~/.bash.d/`  See example.

# Add All Bash extensions

```
#Define the standard location where you check out git projects like devops-application, no ending slash
GIT_HOME="/Users/gregory/GitHub"

# Use Bash shortcuts in devops-application
if [ -f "${GIT_HOME}/devops-application/local/bash-script/all.bash" ]; then

### Put any settings in here, for example, export not necessary
### KUBE_PROMPT_INLINE=true

  source "${GIT_HOME}/devops-application/local/bash-script/all.bash"
fi
```

# Kube Prompt Options....

KUBE_PROMPT_INLINE,  when set ( to anything ), this will update the PS1 to add a basic context
KUBE_PROMPT_COLOR,  Default is red, set to another color or set to "\033[0m" for white

# Configure CLI for OpenVPN

NOTE: Because this requires SUDO it is recommended to update sudoers to not require a password for your account

```
sudo visudo // Edit the sudoers file

```

Using your Mac's username, ie `whoami`

add the following to the end of the file ( location doesn't really matter )

Replace `whoami` with your user name

```
whoami         ALL = (ALL) NOPASSWD: ALL
```

## Install OpenVPN

Run: `brew install openvpn`

### Install Credential Helper

Run: `brew install oathtool`

## Get OpenVPN Configuration

Log into open.paxata.com and download your config file

move and rename the file as `~/.openvpn.opvn`

## Create a password file

create the file `~/.openvpn.creds`

The first line is your user-id and the second line is your password

Make the file only editable by you. `chmod 600 ~/.openvpn.creds`

## Store your MFA key.

create the file `~/.openvpn.mfa`

The first line is your MFA key

Make the file only editable by you. `chmod 600 ~/.openvpn.mfa`

## Connect

At the moment I can't pass in the MFA key so you will have to cut and paste it but it is displayed on the screen to make that easy

Run: `openvpn`
