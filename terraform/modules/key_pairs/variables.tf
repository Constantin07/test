variable "key_name_prefix" {
  description = "The prefix to add to SSH key name"
  default     = ""
}

variable "private_key_algorithm" {
  description = "The algorithm used for SSH key generation"
  default     = "RSA"
}

variable "private_key_rsa_bits" {
  description = "The size in bits of SSH key"
  default     = "2048"
}

variable "private_key_ecdsa_curve" {
  description = "The name of the elliptic curve to use when ECDSA algorithm is used"
  default     = "P224"
}
