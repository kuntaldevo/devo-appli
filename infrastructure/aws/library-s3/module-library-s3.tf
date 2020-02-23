

module library-s3 {

  source = "../module/library-s3"

  tag-map = var.tag-map

  library-name = "${module.library-name.name}"
}


module library-name {

  source = "../module/library-s3-name"

  tag-map = var.tag-map

}
