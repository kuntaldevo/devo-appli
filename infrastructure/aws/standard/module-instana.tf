
#Import the Instana IPs
#Used a module because it was simple where all of the variables are just outputs defined in the module

module "instana" {

  source = "../../shared-module/instana"

}
