
A; Things we're missing

maxheapsize
initialheapsize
gc setting
px.total.cache.capacity


instana settings to enable web sockets.


# PAX Server

under `spec.paxserver.applicationProperties` just gets added to the `px.properties`

set the `px.xx.*` options

###Future

jvmOptions:  opaque options and passed to the JVM

# Pipeline Proxy

under `spec.pipelineProxy.applicationProperties` These are set as ENV Vars in the shell for Pipeline Proxy

Example: JAVA_HOME: "/usr/local/bin/java"

Pass a bunch of JVM settings using the `JAVA_TOOL_OPTIONS` env var.  Example:  JAVA_TOOL_OPTIONS: "-D something -DanotherTHing -DthirdTime"

# Drivers & Executors ( are these pipeline JVM options ? )

Apache Docs:  https://spark.apache.org/docs/latest/running-on-kubernetes.html#configuration

You can find the properties on the pod at `/opt/spark/conf/spark.properties`

defaults are set by the installationOperator

for pipeline drivers/executors, you need to use the spark launcher configuration options and set those in the PaxInstallation yaml under `spec.pipelineProxy.applicationProperties`

_except_ for max heap space (see memoryOverheadFactor)

Properties prefixed with `px_pps_spark_conf_` have that prefix stripped off and have `_` replaced with `.`, and will then be passed directly to spark launcher as a conf property

## Global Settings

px_pps_spark_conf_spark_kubernetes_memoryOverheadFactor

* this is a multiplier on top of the memory that you request. So if you say you want drivers to use 16GB and the memoryOverhead is 0.99 (which is the default), then the max heap space for the jvm will be 16GB and the Pod will request ~32GB from Kubernetes

## Driver Specific Settings

px_pps_spark_conf_spark_driver_cores
px_pps_spark_conf_spark_driver_memory

px_pps_spark_conf_spark_driver_extraJavaOptions

## Executor Specifc Settings

px_pps_spark_conf_spark_executor_cores
px_pps_spark_conf_spark_executor_memory
px_pps_spark_conf_spark_executor_extraJavaOptions
