
# IPs that Instana uses.
# TODO: Instead of static IPs use DNS to lookup the IPs
# https://docs.instana.io/quick_start/on_prem/outbound_network_access_requirements/#linux-software-repositories-for-instanas-backend


#Repository: https://setup.instana.io/
output "instana-setup-cidr" {

  value = "52.50.76.138/32"

}

#Docker Registry: https://registry.hub.docker.com/
output "instana-docker-cidr" {

  value = ""

}

# Agent Repository: http://repo-public.instana.io/
output "instana-repository-cidr-map" {

  value = [
      {
        cidr = "52.43.167.95/32"
        description = "repo-public.instana.io"
      },
      {
        cidr = "54.70.95.205/32"
        description = "repo-public.instana.io"
      }
    ]
}

# Agent Saas: https://saas-us-west-2.instana.io/
output "instana-saas-cidr-map" {

  value = [
      {
        cidr = "52.41.237.191/32"
        description = "saas-us-west-2.instana.io"
      },
      {
        cidr = "52.11.135.223/32"
        description = "saas-us-west-2.instana.io"
      }
    ]
}
