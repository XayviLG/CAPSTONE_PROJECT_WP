/**resource "aws_s3_bucket" "cpstn_s3-wordpress" {
  bucket = "cpstn_s3-wordpress"
  
  tags = {
    Name = "cpstn_S3-wordpress"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3-ownership" {
  bucket = aws_s3_bucket.cpstn_s3-wordpress.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "cpstn_s3-wordpress-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3-ownership]
  bucket = aws_s3_bucket.cpstn_s3-wordpress.id
  acl    = "private"
}**/