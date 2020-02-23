
# This gets the Volume Labels that will be used to find and setup the worker's cache

module spark-worker-volume-label {

  source = "../module/volume-label"

  create = var.feature-spark-cache-esb

  volume-total = var.spark-worker-cache-volume-count

}
