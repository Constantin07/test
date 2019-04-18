variable "kube_config_file" {
  description = "Path to kubectl configuration file."
  default     = "~/.kube/config"
}

variable "token_reviewer_jwt" {
  description = "Token associated with vault-auth service account in K8s."
}
