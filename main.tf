provider "vcd" {
  url                   = "https://xxx/api"
  user                  = "xxx"
  password              = "xxx"
  org                   = "System"
  max_retry_timeout     = "120"
  allow_unverified_ssl  = "true"
  logging               = "true"
}
resource "vcd_org" "demo_org" {
  name                  = "xxx"
  full_name              = "xxx"
  is_enabled            = "true"
  stored_vm_quota       = "10"
  deployed_vm_quota     = "10"
  delete_force = "true"
  delete_recursive = "true"
}
resource "vcd_org_user" "demo_org_admin" {
  org                   = "${vcd_org.demo_org.name}"
  name                  = "xxx"
  full_name             = "xxx"
  description           = "Org Admin"
  role                  = "Organization Administrator"
  password              = "xxx"
  depends_on = [

    vcd_org.demo_org,

  ]
}
resource "vcd_org_vdc" "demo_vdc" {
  org                   = "${vcd_org.demo_org.name}"
  name                  = "xxx"
  description           = "terraform create Allocation VDC"
  allocation_model      = "AllocationPool"
  network_pool_name     = "xxx"
  provider_vdc_name     = "xxx"
  network_quota         = "10"
  cpu_speed             = "1000"
  memory_guaranteed     = "0.2"
  cpu_guaranteed        = "0.2"

  compute_capacity {
    cpu {
      allocated = 5000
    }

    memory {
      allocated = 5120
    }
  }
  storage_profile {
    name     = "Datastore-LocalDisk-Raid5"
    limit    = 30000
    default  = true
  }
  delete_force              = "true"
  delete_recursive          = "true"
  enabled                    = "true"
  enable_thin_provisioning  = "true"
  enable_fast_provisioning  = "true"
}

resource "vcd_edgegateway" "egw" {
  org = "${vcd_org.demo_org.name}"
  vdc = "${vcd_org_vdc.demo_vdc.name}"

  name                    = "demo-egw"
  description             = "new edge gateway"
  configuration           = "compact"
  advanced                = true

  external_network {
    name = "External-Network-01"

    subnet {
      ip_address            = "xxx"
      gateway               = "xxx"
      netmask               = "xxx"
      use_for_default_route = true
    }
  }
}
