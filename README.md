# Deploy VM with configured network
## Usage
```hcl
module "vm1" {
  source = "HopeUA/vm/azurerm"

  namespace = "ServiceName"
  name = "VM1"
  location = "WestEurope"
  vm_size = "Basic_A1"
}
```
