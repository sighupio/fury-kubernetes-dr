variable bucket_prefix {
    default = "velero"
}

variable name {}
variable env {}

provider "google" {
    version = "2.0.0"
}

