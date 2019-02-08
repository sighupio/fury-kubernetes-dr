variable bucket_prefix {
    default = "velero"
}

variable name {}
variable env {}

provider "google" {
    version = "1.20.0"
}

