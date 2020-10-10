output "key_name" {
  value = {
    public  = aws_key_pair.public.key_name
    private = aws_key_pair.private.key_name
  }
}

output "public_key_pem" {
  value = {
    public  = tls_private_key.public.public_key_pem
    private = tls_private_key.private.public_key_pem
  }
}

output "public_key_openssh" {
  value = {
    public  = tls_private_key.public.public_key_openssh
    private = tls_private_key.private.public_key_openssh
  }
}

output "private_key_pem" {
  sensitive = true

  value = {
    public  = tls_private_key.public.private_key_pem
    private = tls_private_key.private.private_key_pem
  }
}
