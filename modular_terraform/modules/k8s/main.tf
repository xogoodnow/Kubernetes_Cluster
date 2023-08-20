
resource "null_resource" "k8s" {
  provisioner "local-exec" {
    command = "sleep 111  && PWD='../' ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yaml ../playbook/setup.yaml --private-key sshkey/private_key.pem"
  }
}

