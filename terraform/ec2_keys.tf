data "aws_region" "current" {
  current = true
}

resource "aws_key_pair" "aws" {
  key_name   = "aws"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCa/340+m79DvxbhOMSZC/pWI0f3cqjojNufJtdj7u1C4rfbX2kcb1FkBGuOEpPPAhuNZLGtkRvX5u5rnw7ZCV7Q+KZvytgT0XERmq/Q1PHfMnoHQHiTnbb0Od0kvdwD2ma+vXYf2+znpqkdSHJi9gMx3CJ81Owxwh9HoHPwWe1qFlYdOctM/VMh3L3liRqi5AKXtv4Uy3vh6XKvwsrdttL6XoMIwA0BrNujXV0BAg2YPUqH0kBScSTIkH3YxIiMAg47QCpR7/5i5bzMS1UyYVGHtibxcsI/TAkqBz7ochRVpfhgvObUKDzCgJOvN1huNusgvO+ZRC5gVwDzEVboP3p aws"
}

#output "key_fingerprint" {
#  value = "${aws_key_pair.aws.fingerprint}"
#}

