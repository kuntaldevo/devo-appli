export KUBENS=''
DEFAULT_KUBE_PROMPT_COLOR="\033[1;31m"
NC='\033[0m'

alias kb='kubectl_bash'
alias kns='nskubectl'
alias k='ekubectl'
alias ke='kgev'
alias kev='kgev'
alias kdev='kd events'
alias kg='k get'
alias kgev='kg events --sort-by=.metadata.creationTimestamp'
alias kgcj='kg cronjob'
alias kgcm='kg configmap'
alias kgcr='kg clusterrole'
alias kgcrb='kg clusterrolebinding'
alias kgcrd='kg customresourcedefinitions'
alias kgd='kg deployment'
alias kgds='kg daemonset'
alias kge='kg egress'
alias kgi='kg ingress'
alias kgj='kg job'
alias kgn='kg nodes'
alias kgns='kg namespace'
alias kgnp='kg networkpolicy'
alias kgp='kg pod'
alias kgs='kg service'
alias kgsa='kg sa'
alias kgse='kg secret'
alias kgss='kg statefulset'
alias kgv='kg volume'
alias kgpv='kg persistentvolume'
alias kgpvc='kg persistentvolumeclaims'
alias kgacj='kubectl get cronjob --all-namespaces'
alias kgacm='kubectl get configmap --all-namespaces'
alias kgacr='kubectl get clusterrole --all-namespaces'
alias kgacrb='kubectl get clusterrolebinding --all-namespaces'
alias kgacrd='kubectl get customresourcedefinitions'
alias kgad='kubectl get deployment --all-namespaces'
alias kgads='kubectl get daemonset --all-namespaces'
alias kgae='kubectl get egress --all-namespaces'
alias kgai='kubectl get ingress --all-namespaces'
alias kgaj='kubectl get job --all-namespaces'
alias kgan='kgn'
alias kgans='kubectl get namespace --all-namespaces'
alias kganp='kubectl get networkpolicy --all-namespaces'
alias kgap='kubectl get pod --all-namespaces'
alias kgas='kubectl get service --all-namespaces'
alias kgasa='kubectl get sa --all-namespaces'
alias kgase='kubectl get secret --all-namespaces'
alias kgass='kubectl get statefulset --all-namespaces'
alias kgav='kubectl get volumes --all-namespaces'
alias kgapv='kubectl get pv --all-namespaces'
alias kgapvc='kubectl get pvc --all-namespaces'
alias kd='k describe'
alias kdcm='kd configmap'
alias kdd='kd deployment'
alias kdds='kd daemonset'
alias kdj='kd job'
alias kdn='kd node'
alias kdnp='kd networkpolicy'
alias kdp='kd pod'
alias kds='kd service'
alias kdss='kd statefulset'
alias ko='k -o yaml'
alias kocm='ko get configmap'
alias klog='k logs'
alias kaf='k apply -f'
alias kl='saml_login $@'
alias kdel='k delete'
alias kdelete='k delete'
alias kga='kubectlgetall'

alias kopax='ko get pax'
alias kgpax='kg pax'
alias kgapax='kg pax --all-namespaces'

function kube_context() {
	echo "[$(basename $(kubectl config current-context))]"
}

function ekubectl() {
    if [[ -z "$KUBENS" ]]; then
        echo "Running without namespace: kubectl $@"
        kubectl "$@"
    else
        echo "Running with namespace: kubectl -n $KUBENS $@"
        kubectl -n "$KUBENS" "$@"
    fi
}

function nskubectl() {
    export KUBENS="$1"
	
    if [[ "$#" -gt 1 ]]; then
        ekubectl "${@:2}"
    fi
}

function kubectl_bash() {
    ekubectl exec -it "$1" bash
}

function saml_login() {
    local profile=${1:-awsdevadmin}

    saml2aws login --url=https://sso.jumpcloud.com/saml2/"$profile" --force
    export AWS_PROFILE=saml
}

function kubectlgetall {
	for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
		kg ${i}
	done
}

#Process any parameters etc
function updateKubePrompt() {
	if [[ -z $KUBE_PROMPT_COLOR ]]; then
		PROMPT_COLOR="$DEFAULT_KUBE_PROMPT_COLOR"
	else
		PROMPT_COLOR="$KUBE_PROMPT_COLOR"
	fi
}

# This one can only be used via PROMPT_COMMAND and must appear on a new line
function newlineKubePrompt() {
	updateKubePrompt
	echo -e "${PROMPT_COLOR}K8s: $(kube_context)$NC"
}

# This one is for PS1
#https://unix.stackexchange.com/a/124409/241110
function inlineKubePrompt() {
	updateKubePrompt
	local new_entry="\[$PROMPT_COLOR\]\$(kube_context)\[$NC\]"

	if [ -z "$PS1" ]; then
		PS1="$new_entry"
	else
		case "$PS1" in
			*"$new_entry"*)
				:;;
			*)
				PS1="$new_entry$PS1"
				;;
		esac
	fi
}

function install-new-line-prompt {
	local new_entry="newlineKubePrompt"

	if [ -z "$PROMPT_COMMAND" ]; then
		PROMPT_COMMAND="$new_entry"
	else
		PROMPT_COMMAND=${PROMPT_COMMAND%% }; # remove trailing spaces
		PROMPT_COMMAND=${PROMPT_COMMAND%\;}; # remove trailing semi-colon

		case ";$PROMPT_COMMAND;" in
			*";$new_entry;"*)
				:;;
			*)
				PROMPT_COMMAND="$PROMPT_COMMAND;$new_entry"
				;;
		esac
	fi
}

function install-inline-prompt {
	local new_entry='inlineKubePrompt'

	if [ -z "$PROMPT_COMMAND" ]; then
		PROMPT_COMMAND="$new_entry"
	else
		PROMPT_COMMAND=${PROMPT_COMMAND%% }; # remove trailing spaces
		PROMPT_COMMAND=${PROMPT_COMMAND%\;}; # remove trailing semi-colon

		case ";$PROMPT_COMMAND;" in
			*";$new_entry;"*)
				:;;
			*)
				PROMPT_COMMAND="$PROMPT_COMMAND;$new_entry"
				;;
		esac
	fi
}

###  Warning: PROMPT_COMMAND generally should not be used to print characters directly to the prompt.
###  Characters printed outside of PS1 are not counted by Bash, which will cause it to incorrectly place the cursor and clear characters.
###  Either use PROMPT_COMMAND to set PS1 -->  https://stackoverflow.com/a/13997892/349091
### or look at embedding commands, as I did here
function kube-prompt-install {
	if [[ -n "${KUBE_PROMPT_INLINE}" ]]; then
		install-inline-prompt
	else
		install-new-line-prompt
	fi
}

kube-prompt-install
