# Features

Using these variable, allow the servers to self-configure them selves automatically on their initial startup.

## Paxata server

### feature_library

* local ( default )
* s3
* hdfs

### feature_source

Defines where to find the RPM to install

* s3
* teamcity
* flash

### library_auth

a Breakdown further of HDFS defining the authorization type

* simple
* kerberos
