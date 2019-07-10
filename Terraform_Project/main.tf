#####################################################################
##
##      Created 7/10/19 by admin. For Cloud vmware-connection for Terraform_Project
##
#####################################################################

## REFERENCE {"network_reference":{"type": "vsphere_reference_network"}}

terraform {
  required_version = "> 0.8.0"
}

provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.vsphere_server}"

  allow_unverified_ssl = "${var.allow_unverified_ssl}"
  version = "~> 1.2"
}


data "vsphere_virtual_machine" "vm_1_template" {
  name          = "${var.vm_1_template_name}"
  datacenter_id = "${data.vsphere_datacenter.vm_1_datacenter.id}"
}

data "vsphere_datacenter" "vm_1_datacenter" {
  name = "${var.vm_1_datacenter_name}"
}

data "vsphere_datastore" "vm_1_datastore" {
  name          = "${var.vm_1_datastore_name}"
  datacenter_id = "${data.vsphere_datacenter.vm_1_datacenter.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network_network_name}"
  datacenter_id = "${data.vsphere_datacenter.vm_1_datacenter.id}"
}

resource "vsphere_virtual_machine" "vm_1" {
  name          = "${var.vm_1_name}"
  datastore_id  = "${data.vsphere_datastore.vm_1_datastore.id}"
  num_cpus      = "${var.vm_1_number_of_vcpu}"
  memory        = "${var.vm_1_memory}"
  guest_id = "${data.vsphere_virtual_machine.vm_1_template.guest_id}"
  resource_pool_id = "${var.vm_1_resource_pool}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.vm_1_template.id}"
  }
  disk {
    name = "${var.vm_1_disk_name}"
    size = "${var.vm_1_disk_size}"
  }
}