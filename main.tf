provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_virtual_network" "zbx_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "zbxVCN"
  dns_label      = "zbxvcn"
}

resource "oci_core_subnet" "zbx_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "zbxSubnet"
  dns_label         = "zbxsubnet"
  security_list_ids = [oci_core_security_list.zbx_security_list.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.zbx_vcn.id
  route_table_id    = oci_core_route_table.zbx_route_table.id
  dhcp_options_id   = oci_core_virtual_network.zbx_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "zbx_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "zbx_IG"
  vcn_id         = oci_core_virtual_network.zbx_vcn.id
}

resource "oci_core_route_table" "zbx_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.zbx_vcn.id
  display_name   = "zbx_RouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.zbx_internet_gateway.id
  }
}

resource "oci_core_security_list" "zbx_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.zbx_vcn.id
  display_name   = "zbx_SecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3000"
      min = "3000"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3005"
      min = "3005"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }
}

resource "oci_core_instance" "zbx_frontend" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "zbx_frontend"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.zbx_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "zbxfrontend"
  }

  source_details {
    source_type = "image"
    source_id   = var.images[var.region]
  }

  metadata = {
    ssh_authorized_keys = file(var.public_key_oci)
    user_data = base64encode(file("./userdata/aio_bootstrap"))
  }
}