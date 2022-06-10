data "external" "get_ip_addres_using_shell" {
  program = ["bash","scripts/get_ip_address.sh"]
}
