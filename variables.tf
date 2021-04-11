variable "origin_region" {
  type        = "string"
  description = "AWS region for the source bucket"
  default	  = "us-east-1"
}

variable "replica_region" {
  type        = "string"
  description = "AWS region for the destination bucket"
  default	  = "us-west-2"
}

variable "bucket_name" {
  type        = "string"
  description = "Name for source s3 bucket"
  default     = "veerum-poc-east-1"
}


variable "dest_bucket_name" {
  type        = "string"
  description = "Name for dest s3 bucket"
  default     = "veerum-poc-west-2"
}
