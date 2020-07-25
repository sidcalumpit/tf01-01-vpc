resource "aws_key_pair" "bastion" {
    key_name        = "bastion-key"
    public_key      = "data.template_file.bastion_public_key.rendered"
}

resource "aws_launch_configuration" "bastion" {
# Launch Configuration can't be updated after creation with the AWS API.
# In order to update a Launch Configuration, Terrafrom will destroy the 
# existing resource and create a reaplcement.
#
# We're only setting the name_prefix here,
# Terraform will add a random string at the end to keep it unique.
name_prefix = "bastion-"

image_id                    = data.aws_ami.amazon_linux.image_id
instance_type               = var.bastion_instance_type
key_name                    = aws_key_pair.bastion.key_name
associate_public_ip_address = true
# enabling_monitoring       = false
security_groups             =[aws_security_group.bastion.id]

lifecycle {
    create_before_destroy   = true
  }
}

resource "aws_autoscaling_group" "bastion" {
    name                    = "bastion-asg"
    min_size                = 0
    desired_capacity        = 1
    max_size                = 1
    health_check_type       = "EC2"
    launch_configuration    = aws_launch_configuration.bastion.name 
    vpc_zone_identifier     = aws_subnet.public.*.id

    tags = [
      {
          key                = "Name"
          value              = "Bastion"
          propagae_at_launch = true
      },
    ]  
}

# Security group
resource "aws_security_group" "bastion" {
    name_prefix             = "Bastion SG"
    description             = "Allow all inbound traffic"
    vpc_id                  = aws_vpc.main.id 

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "allow_all_ssh" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.bastion.id 
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id = aws_security_group.bastion.id
}
















