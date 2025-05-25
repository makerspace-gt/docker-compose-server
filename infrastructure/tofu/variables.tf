variable "template_id" {
  description = "OpenNebula template ID for VMs"
  type        = string
  default     = "TODO_ADD_TEMPLATE_ID_HERE"
}

variable "github_users" {
  description = "GitHub usernames for SSH key import"
  type        = list(string)
  default     = ["nielsfechtel", "leon2225", "igami", "mattn81", "ReneHezser"]
}
