/**resource "aws_s3_bucket" "mys3-wordpress" {
  bucket = "mys3-wordpress"
  
  tags = {
    Name = "myS3-wordpress"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3-ownership" {
  bucket = aws_s3_bucket.mys3-wordpress.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "mys3-wordpress-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3-ownership]
  bucket = aws_s3_bucket.mys3-wordpress.id
  acl    = "private"
}**/