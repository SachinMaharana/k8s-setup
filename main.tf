provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "kubernetes"
  }
}


resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr
  tags = {
    Name = "kubernetes"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "kubernetes"
  }
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "kubernetes"
  }
}

resource "aws_route_table_association" "rt-assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "kubernetes" {
  name   = "kubernetes-sg"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "kubernetes"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.kubernetes.id
  cidr_blocks       = [var.all_cidr]
}

resource "aws_security_group_rule" "allow_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  security_group_id = aws_security_group.kubernetes.id
  cidr_blocks       = [var.all_cidr]
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.kubernetes.id
  cidr_blocks       = [var.all_cidr]
}
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.kubernetes.id
  cidr_blocks       = [var.all_cidr]
}


resource "aws_security_group_rule" "allow_k8s_https" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  security_group_id = aws_security_group.kubernetes.id
  cidr_blocks       = [var.all_cidr]
}



resource "aws_security_group_rule" "allow_cluster_cidr" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "-1"
  security_group_id = aws_security_group.kubernetes.id
  cidr_blocks       = [var.cluster_cidr]
}


resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "-1"
  security_group_id = aws_security_group.kubernetes.id
  cidr_blocks       = [var.vpc_cidr]
}


resource "aws_security_group_rule" "allow_all_outgoing_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.kubernetes.id
  cidr_blocks       = [var.all_cidr]
}

// Is it necessary?
resource "aws_security_group_rule" "allow_access_from_this_security_group" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "-1"
  security_group_id        = aws_security_group.kubernetes.id
  source_security_group_id = aws_security_group.kubernetes.id
}


resource "aws_key_pair" "ssh" {
  key_name   = var.owner
  public_key = file(var.ssh_public_key_path)
}


resource "aws_instance" "master" {
  count                       = var.master_count
  associate_public_ip_address = true
  ami                         = var.centos_enable ? var.centos : data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.ssh.key_name
  vpc_security_group_ids      = [aws_security_group.kubernetes.id]
  instance_type               = "t3.medium"
  private_ip                  = "10.240.0.1${count.index}"
  subnet_id                   = aws_subnet.subnet.id
  source_dest_check           = false
  tags = {
    Name = "master-${count.index}"
  }
}


resource "aws_instance" "worker" {
  count                       = var.worker_count
  associate_public_ip_address = true
  ami                         = var.centos_enable ? var.centos : data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.ssh.key_name
  vpc_security_group_ids      = [aws_security_group.kubernetes.id]
  instance_type               = "t3.medium"
  private_ip                  = "10.240.0.2${count.index}"
  subnet_id                   = aws_subnet.subnet.id

  source_dest_check = false
  tags = {
    Name = "worker-${count.index}"
  }
}

resource "aws_instance" "etcd" {
  count                       = var.etcd_count
  associate_public_ip_address = true
  ami                         = var.centos_enable ? var.centos : data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.ssh.key_name
  vpc_security_group_ids      = [aws_security_group.kubernetes.id]
  instance_type               = "t3.medium"
  private_ip                  = "10.240.0.3${count.index}"
  subnet_id                   = aws_subnet.subnet.id
  source_dest_check           = false

  tags = {
    Name = "etcd-${count.index}"
  }
}


resource "aws_instance" "lb" {
  count                       = var.lb_count
  associate_public_ip_address = true
  ami                         = var.centos_enable ? var.centos : data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.ssh.key_name
  vpc_security_group_ids      = [aws_security_group.kubernetes.id]
  instance_type               = "t3.small"
  private_ip                  = "10.240.0.4${count.index}"
  subnet_id                   = aws_subnet.subnet.id
  source_dest_check           = false
  tags = {
    Name = "lb-${count.index}"
  }
}





resource "local_file" "kube_inventory" {
  content = templatefile("${path.module}/kube.tpl", {
    list_master = slice(aws_instance.master.*.public_ip, 0, var.master_count),
    list_worker = slice(aws_instance.worker.*.public_ip, 0, var.worker_count)
    list_etcd = slice(aws_instance.etcd.*.public_ip, 0, var.etcd_count)
    list_lb = slice(aws_instance.lb.*.public_ip, 0, var.lb_count),

    list_master_private = slice(aws_instance.master.*.private_ip, 0, var.master_count)
    list_etcd_private = slice(aws_instance.etcd.*.private_ip, 0, var.etcd_count)
    list_worker_private = slice(aws_instance.worker.*.private_ip, 0, var.worker_count)
    list_lb_private = slice(aws_instance.lb.*.private_ip, 0, var.lb_count)

  })
  filename = "ips"
}
