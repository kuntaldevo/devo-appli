
module "library-policy" {

  source = "../module/library-s3-policy"

  create-policy =  "${var.feature-library == "s3" ? 1 : 0}"

  library-name = module.library-name.name

  tag-map = var.tag-map

}
