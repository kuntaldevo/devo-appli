
# Generate each specific User data by using a template file
data "template_file" "user-data" {

  count = var.total-instances

  template = file("${path.module}/${var.template-file}")

  vars = {
    server-role = var.server-role
    env-key = local.env-key
    feature-library = var.feature-library
    feature-ddl = var.feature-ddl
    region-id = local.region-id
    host-name = "${var.host-name}.${var.domain-suffix}"
    host-name-count = "${var.host-name}-${count.index}.${var.domain-suffix}"
    volume-labels = jsonencode( var.volume-labels )
    hdfs-host = var.hdfs-host
    public-domain = var.public-domain
    instana-api-key = var.instana-api-key
  }
}
