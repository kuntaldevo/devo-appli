
# Run the user's bashrc
if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi

# Setup some aliases to make it easier to get around
alias infrastructure="cd ${PROJECT_ROOT}/infrastructure"
alias package="cd ${PROJECT_ROOT}/package"
alias tooling="cd ${PROJECT_ROOT}/tooling"
alias provision="cd ${PROJECT_ROOT}/provision"
alias application="cd ${PROJECT_ROOT}/application"

export PS1="[Package:$DISTRO_ID:$REGION_ID]$ "
