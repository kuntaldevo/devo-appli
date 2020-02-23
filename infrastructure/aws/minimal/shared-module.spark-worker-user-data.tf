
module spark-user-data {

  source = "../../shared-module/user-data"

  tag-map = var.tag-map

  total-instances = var.spark-worker-count
  template-file = "spark.template"
  server-role = "spark-worker"
  host-name = "spark-worker"
  volume-labels = module.spark-worker-volume-label.volume-labels

}
