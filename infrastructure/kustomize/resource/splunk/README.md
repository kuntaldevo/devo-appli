
# Splunk

Source:

https://github.com/splunk/splunk-connect-for-kubernetes/tree/develop/manifests

# Manual Updates

The Config maps have been updated to support being able to properly log errors from the Pax Cluster

The `host` has been change from `MY-SPLUNK-HOST` to `"#{ENV['SPLUNK_HEC_HOST']}"`  There are 4 places this needs to be completed.
