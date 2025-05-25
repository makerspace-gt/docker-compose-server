output "staging_vm_ip" {
  value = opennebula_virtual_machine.staging_vm.ip
  description = "IP address of staging VM"
}

output "production_vm_ip" {
  value = opennebula_virtual_machine.production_vm.ip
  description = "IP address of production VM"
}

output "uptime_vm_ip" {
  value = opennebula_virtual_machine.uptime_vm.ip
  description = "IP address of uptime VM"
}

