variable "kube_config_file" {
  description = "Path to kubectl configuration file."
  type        = string
  default     = "~/.kube/config"
}
