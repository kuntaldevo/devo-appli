
# Setup some aliases to make it easier to get around
alias infrastructure="cd ${PROJECT_ROOT}/infrastructure"
alias package="cd ${PROJECT_ROOT}/package"


function __check_path () {

  current_dir=`pwd`

  if [[ "$current_dir" =~ ^"$PROJECT_ROOT".* ]]; then
    echo "";
  else
    echo -e "${WARNING} You are not in a project directory";
    echo -e "${WARNING} Expected parent path: $PROJECT_ROOT";
    printf "${WARNING} Some Commands may not work\n\r"; # Some deal with a '\n' being stripped off if it's the last character
  fi
}

function __cluster-env () {

  if [[ -z "$STAGE_ID" ]]; then
    echo "Cluster: [$CUSTOMER_ID-$CLUSTER_ID:$REGION_ID]";
  else
    echo "Cluster: [$CUSTOMER_ID-$CLUSTER_ID-$STAGE_ID:$REGION_ID]";
  fi

}

function __customer_app-env () {

    echo "Customer: [$CUSTOMER_ID]";

}

function setShellPrompt() {

  fun_dir=`pwd`

  if [[ $fun_dir == *"/application"* ]]; then
    echo -e "\033[1;33m$(__check_path)$(__customer_app-env)\033[0m"
  elif  [[ $fun_dir == *"/infrastructure"* ]]; then
    echo -e "\033[1;33m$(__check_path)$(__cluster-env)\033[0m"
  else
    echo -e "${WARNING} You are not in a project directory";
    echo -e "${WARNING} Expected parent path: $PROJECT_ROOT";
    printf "${WARNING} Some Commands may not work\n\r"; # Some deal with a '\n' being stripped off if it's the last character
  fi

}

function shell-prompt-install {

  local new_entry="setShellPrompt"

  if [ -z "$PROMPT_COMMAND" ]; then
    PROMPT_COMMAND="$new_entry"
  else
    PROMPT_COMMAND=${PROMPT_COMMAND%% }; # remove trailing spaces
    PROMPT_COMMAND=${PROMPT_COMMAND%\;}; # remove trailing semi-colon

    case ";$PROMPT_COMMAND;" in
      *";$new_entry;"*)
        # echo "PROMPT_COMMAND already contains: $new_entry"
        :;;
      *)
        PROMPT_COMMAND="$PROMPT_COMMAND;$new_entry"
        # echo "PROMPT_COMMAND does not contain: $new_entry"
        ;;
    esac
  fi

}

shell-prompt-install

# Run the user's bashrc
if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi
