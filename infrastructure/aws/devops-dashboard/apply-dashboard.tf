

variable "dashboard-url"
{

  default = "https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml"

}

data "http" "dashboard-url" {
  url = "${var.dashboard-url}"

  # Optional request headers
  request_headers {
    "Accept" = "application/json"
  }
}


resource "null_resource" "apply-dashboard" {

  triggers = {
     on-change = "${ md5(data.http.dashboard-url.body) }"
  }

  provisioner "local-exec" {

    command = "kubectl apply -f ${var.dashboard-url}"

  }

  provisioner "local-exec" {
    when = "destroy"

    command = "kubectl delete -f ${var.dashboard-url}"

    on_failure = "continue"
  }

#NOTE: Doesn't require depends-on because we are using a URL
}
