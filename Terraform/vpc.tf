module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  name    = "eks-vpc"
  cidr    = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway    = true
  single_nat_gateway    = true
  create_igw            = true
  map_public_ip_on_launch = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "null_resource" "add_custom_tags_to_public_subnet" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
aws ec2 create-tags --resources ${module.vpc.public_subnets[0]} --tags "Key=kubernetes.io/role/elb,Value=1" --region ${var.AWS_REGION}
aws ec2 create-tags --resources ${module.vpc.public_subnets[0]} --tags "Key=kubernetes.io/cluster/${var.cluster_name},Value=shared" --region ${var.AWS_REGION}
EOF
  }

  depends_on = [
    module.vpc.public_subnets
  ]
}
