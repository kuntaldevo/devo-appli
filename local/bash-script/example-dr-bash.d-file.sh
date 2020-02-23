# cat ~/.bash.d/gregory.bonk.sh
#!/usr/bin/env bash



### GetOpt is required for Devops-Application and needs to be on the path
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

#Define the standard location where you check out git projects like devops-application, no ending slash
GIT_HOME="/Users/gregory.bonk/workspace"

#Define what the basic Prompt should be
PS1_DEFAULT='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '


# Use Bash shortcuts in devops-application
if [ -f "${GIT_HOME}/devops-application/local/bash-script/all.bash" ]; then

### Put any settings in here, for example, export not necessary
### KUBE_PROMPT_INLINE=true

  source "${GIT_HOME}/devops-application/local/bash-script/all.bash"
fi


# Use Git Prompt
#https://formulae.brew.sh/formula/bash-git-prompt
#https://github.com/magicmonty/bash-git-prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1

  GIT_PROMPT_START="${GREEN}Git:${NC}"
  GIT_PROMPT_END="\n$PS1_DEFAULT"
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi
