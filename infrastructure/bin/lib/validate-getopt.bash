

###
# Validate GetOpt is of correct version, if Mac see Wiki Devops Onboarding
getopt --test   >/dev/null 2>&1
if [[ $? -ne 4 ]]; then
  echo "${ERROR}The Latest version of GetOpt is required."
  echo "${ERROR}If Mac see Wiki Devops Onboarding."
  exit 1
fi
