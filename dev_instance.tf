resource "aws_launch_configuration" "dev" {
# Launch Configuration can't be updated after creation with the AWS API.
# In order to update a Launch Configuration, Terrafrom will destroy the 
# existing resource and create a reaplcement.
#
# We're only setting the name_prefix here,
# Terraform will add a random string at the end to keep it unique.
name_prefix             = "dev-"

image_id                    = data.aws_ami.amazon_linux.image_id
instance_type               = var.bastion_instance_type
key_name                    = aws_key_pair.bastion.key_name
associate_public_ip_address = false
# enabling_monitoring         = false
security_groups             =["aws_security_group.dev.id"]

lifecycle {
    create_before_destroy   = true
  }
}

resource "aws_autoscaling_group" "dev" {
    name                    = "dev-asg"
    min_size                = 0 
    desired_capacity        = 0
    max_size                = 1
    health_check_type       = "EC2"

    launch_configuration    = "launch_configuration.dev.name" 

    vpc_zone_identifier     = aws_subnet.private.*.id 

}
