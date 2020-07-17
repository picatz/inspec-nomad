datacenter = "dc1"
log_level = "DEBUG"
data_dir = "/tmp/nomad-agent"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  options {
    # must run as root
    "driver.exec.enable" = "1"
    "driver.raw_exec.enable" = "1"
    "driver.docker.enable" = "1"
  }
}