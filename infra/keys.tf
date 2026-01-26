# ssh-keygen -t rsa -b 4096 -f ~/.ssh/kts_jenkins_key
# ssh-keygen -t rsa -b 4096 -f ~/.ssh/kts_jump_host_key
# ssh-keygen -t rsa -b 4096 -f ~/.ssh/kts_sonaq_key
# ssh-keygen -t rsa -b 4096 -f ~/.ssh/kts_depl_key

# create a key pair
resource "aws_key_pair" "keys" {

  for_each = var.key_pairs

  key_name   = each.value.key_pair_name
  public_key = file(each.value.key_path)

}