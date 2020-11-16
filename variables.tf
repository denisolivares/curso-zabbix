variable "tenancy_ocid" {}

variable "user_ocid" {}

variable "fingerprint" {}

variable "private_key_path" {}

variable "public_key_oci" {}

variable "compartment_ocid" {}

variable "region" {}

variable "instance_shape" {
    default = "VM.Standard.E2.1"
}

variable "images" {
  type = map(string)
  default = {
    sa-saopaulo-1  = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa6wbujcvvdzq7kn7oadku6ysscxgsoacvcbp2an7cyzuoxlzy3teq"
  }
}