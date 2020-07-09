variable "key_name_prefix" {
  description = "The prefix to add to SSH key name"
  type        = string
  default     = ""
}

variable "private_key_algorithm" {
  description = "The algorithm used for SSH key generation"
  type        = string
  default     = "RSA"
}

variable "private_key_rsa_bits" {
  description = "The size in bits of SSH key"
  type        = number
  default     = 2048
}

variable "private_key_ecdsa_curve" {
  description = "The name of the elliptic curve to use when ECDSA algorithm is used"
  type        = string
  default     = "P224"
}
