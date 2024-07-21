terraform {
  backend "s3" {
    bucket         = "terraform-backend-terraformbackends3bucket-aucuskghlaba"
    key            = "testing"
    region         = "us-east-1"
    dynamodb_table = "terraform-backend-TerraformBackendDynamoDBTable-1JDNBFEXYCEZD"
  }
}




