variable "sgroup_kube_ingress_with_cidr_blocks" { 
type = list(object({
  from_port       = string
  to_port         = string
  protocol        = string
  description     = string
  cidr_blocks     = string
  }))
default = [
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      description = "Kubernetes API server"
      cidr_blocks = "172.28.0.0/16"
    },
    {
      from_port   = 2379
      to_port     = 2380
      protocol    = "tcp"
      description = "etcd server client API"
      cidr_blocks = "172.28.0.0/16"
    },
    {
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      description = "Kubelet API"
      cidr_blocks = "172.28.0.0/16"
    },
    {
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      description = "Workers NodePort Services"
      cidr_blocks = "172.28.0.0/16"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh connection for debuging purposes"
      cidr_blocks = "172.28.0.0/16"
    },
    {
      from_port   = 179
      to_port     = 179
      protocol    = "tcp"
      description = "BGP - calico"
      cidr_blocks = "172.28.0.0/16"
    },
    {
      from_port   = 4789
      to_port     = 4789
      protocol    = 17
      description = "VXLAN - calico"
      cidr_blocks = "172.28.0.0/16"
    },
    {
      from_port   = 5473
      to_port     = 5473
      protocol    = 6
      description = "VXLAN - calico"
      cidr_blocks = "172.28.0.0/16"
    },
    {
      from_port     = 0
      to_port     = 65535
      protocol    = 4
      description = "IP-in-IP - calico"
      cidr_blocks = "172.28.0.0/16"
    },
]
}


variable  "private_subnet_tags" {
type = map(string)
default = {
  "kubernetes.io/cluster/clustera.akube" = "shared"
  }
}

variable  "public_subnet_tags" {
type = map(string)
default = {
  "kubernetes.io/cluster/clustera.akube" = "shared"
  }
}

variable "private_subnets_indexes" {
  type = list
  default = ["0", "1", "2"]
}

variable "private_subnets" {
  type = list
  default = ["172.28.1.0/24", "172.28.2.0/24", "172.28.3.0/24"]
}
