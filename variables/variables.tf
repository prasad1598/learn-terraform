variable "c" {
  default = {
    x = 10
    y = 20
    z = true
  }
}

output "c1" {
  value = var.c["x"]
}