locals {
  bucket_name             = "origin-s3-bucket-${var.bucket_name}"
  destination_bucket_name = "replica-s3-bucket-${var.dest_bucket_name}"
  origin_region           = "${var.origin_region}"
  replica_region          = "${var.replica_region}"
}

provider "aws" {
  region = local.origin_region
}

provider "aws" {
  region = local.replica_region

  alias = "replica"
}

resource "random_pet" "this" {
  length = 3
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "replica" {
  provider = "aws.replica"

  description             = "S3 bucket replication KMS key"
  deletion_window_in_days = 8
}

module "replica_bucket" {
  source = "./terraform-aws-s3-bucket/"

  providers = {
    aws = "aws.replica"
  }

  bucket = local.destination_bucket_name
  acl    = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
         sse_algorithm = "aws:kms"
       }
     }
  }
  
 website = {
   enabled = false
   index_document = "index.html"
      error_document = "error.html"
   routing_rules = jsonencode([{
     Condition : {
       KeyPrefixEquals  :  "docs/"
     },
     Redirect  : {
       ReplaceKeyPrefixWith  : "documents/"
    }
   }])
 }

  versioning = {
    enabled = true
  }
}
module "s3_bucket" {
  source = "./terraform-aws-s3-bucket/"

  bucket = local.bucket_name
  acl    = "private"
  
  website = {
   enabled = true
   index_document = "index.html"
   error_document = "error.html"
   routing_rules = jsonencode([{
     Condition : {
       KeyPrefixEquals  :  "docs/"
     },
     Redirect  : {
       ReplaceKeyPrefixWith  : "documents/"    
    }
   }])
  }

  versioning = {
    enabled = true
  }
 
 server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
         sse_algorithm = "aws:kms"
       }
     }
  }


  replication_configuration = {
    role = aws_iam_role.replication.arn

    rules = [
      {
        id       = "foo"
        status   = "Enabled"
        priority = 10

        source_selection_criteria = {
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        filter = {
          prefix = "one"
          tags = {
            ReplicateMe = "Yes"
          }
        }

        destination = {
          bucket             = "arn:aws:s3:::${local.destination_bucket_name}"
          storage_class      = "STANDARD"
          replica_kms_key_id = aws_kms_key.replica.arn
          account_id         = data.aws_caller_identity.current.account_id
          access_control_translation = {
            owner = "Destination"
          }
        }
      },
      {
        id       = "bar"
        status   = "Enabled"
        priority = 20

        destination = {
          bucket        = "arn:aws:s3:::${local.destination_bucket_name}"
          storage_class = "STANDARD"
        }


        filter = {
          prefix = "two"
          tags = {
            ReplicateMe = "Yes"
          }
        }

      },

    ]
  }

}
