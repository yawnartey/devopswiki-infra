variable "subnet_ids" {
  type = map(string)
}
variable "fe_security_group_id" {
  type = string
}
variable "be_security_group_id" {
  type = string
}
variable "yaw_public_key" {
  type = string
}
variable "postgres_user" {
  type = string
}
variable "postgres_password" {
  type = string
}
variable "instance_profile" {
  type = string
}
variable "env" {
  type = string
}
variable "domain" {
  type = string
}