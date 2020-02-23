
I wanted to put some docs here instead of on the wiki.

ClearData provided a login to the console.  Clear data account # is 752595142617

I created a Auth Key combination

in my local AWS credentials I created a [cleardata] profile with the created credentials.

set my environment to cleardata `export AWS_PROFILE=cleardata`


Disable Daemonset

kubectl patch daemonset splunk-kubernetes-logging -p '{"spec": {"template": {"spec": {"nodeSelector": {"non-existing": "true"}}}}}'

Enable Daemonset

kubectl -n <namespace> patch daemonset <name-of-daemon-set> --type json -p='[{"op": "remove", "path": "/spec/template/spec/nodeSelector/non-existing"}]'
