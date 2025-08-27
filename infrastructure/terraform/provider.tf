terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

variable "region"   { type = string}

variable "use_custom_endpoints" {
  type    = bool
  default = false
}

variable "custom_endpoints" {
  type = object({
    apigateway     = optional(string)
    cloudwatch     = optional(string)
    dynamodb       = optional(string)
    ec2            = optional(string)
    events         = optional(string)
    iam            = optional(string)
    lambda         = optional(string)
    logs           = optional(string)
    s3             = optional(string)
    secretsmanager = optional(string)
    ssm            = optional(string)
    sns            = optional(string)
    sqs            = optional(string)
    sts            = optional(string)
  })
  default = {} # empty => no endpoints block rendered
}

provider "aws" {
  region  = var.region

  
  
  # Helpful for local emulation
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  dynamic "endpoints" {
    for_each = var.use_custom_endpoints ? [1] : []
    content {
      apigateway      = try(var.custom_endpoints.apigateway, null)
      dynamodb        = try(var.custom_endpoints.dynamodb, null)
      lambda          = try(var.custom_endpoints.lambda, null)
      s3              = try(var.custom_endpoints.s3, null)
      sqs             = try(var.custom_endpoints.sqs, null)
      sns             = try(var.custom_endpoints.sns, null)
      sts             = try(var.custom_endpoints.sts, null)
      iam             = try(var.custom_endpoints.iam, null)
    }
  }

}