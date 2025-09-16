output "instance_id" {
  value = aws_instance.packer_vm.id
}

output "public_ip" {
  value = aws_instance.packer_vm.public_ip
}
