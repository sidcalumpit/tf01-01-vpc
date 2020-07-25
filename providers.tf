# https://www.terraform.io/docs/providers/aws/index.html


provider "aws" {
    region  = var.region
#   instead of ---> version = "~> 2.70", we will restrict it to "2.70"
    version = "2.70"   
}

/* yuric@DESKTOP-AQHRC6H MINGW64 ~/Google Drive/LEARNING TRAININGS/CODE/code_tf/Handson-Infrastructure_Automation_With_Terraform_onAWS/vpc (master)
$
$ terraform providers
.
├── provider.aws 2.70
└── provider.template


yuric@DESKTOP-AQHRC6H MINGW64 ~/Google Drive/LEARNING TRAININGS/CODE/code_tf/Handson-Infrastructure_Automation_With_Terraform_onAWS/vpc (master)
$ ls -l ~/.terraform.d/plugin-cahce/linux_amd64/
provider "template" {
  version = "1.0"
}

once you get the provider template number, you can replace the above provider with this template below :

provider "template" {
  version = "1.0"
}

*/

terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
      bucket  = "packt-terraform-section2-bucket-20200717"

      key     = "dev/backbone"

      region  = "us-east-2"

      encrypt = "true"
  } 
}
# https://www.terraform.io/docs/providers/aws/d/s3_bucket.html

