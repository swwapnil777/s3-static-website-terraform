terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }

  }
}

provider "aws" {
  # Configuration options

  region = "ap-south-1"
}

resource "aws_s3_bucket" "mywebapp-bucket" {

  bucket = "my-web-app-xyzc1"



}






resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mywebapp-bucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "mywebapp" {

  bucket = aws_s3_bucket.mywebapp-bucket.bucket

  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" : [
        {
          "Sid"       = "PublicReadGetObject",
          "Effect"    = "Allow",
          "Principal" = "*",
          "Action" = [
            "s3:GetObject"
          ],
          "Resource" = [
            "arn:aws:s3:::my-web-app-xyzc1/*"
          ]
        }
      ]
    }
  )

}




resource "aws_s3_object" "index_html" {

  bucket = aws_s3_bucket.mywebapp-bucket.bucket

  source = "./index.html"

  key = "index.html"

  content_type = "text/html"

}

resource "aws_s3_object" "styles_css" {

  bucket       = aws_s3_bucket.mywebapp-bucket.bucket
  source       = "./styles.css"
  key          = "styles.css"
  content_type = "text/css"

}


resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp-bucket.bucket

  index_document {
    suffix = "index.html"
  }
}

output "name" {
  value = aws_s3_bucket_website_configuration.mywebapp.website_endpoint
}

