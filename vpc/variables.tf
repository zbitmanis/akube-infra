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
]
}