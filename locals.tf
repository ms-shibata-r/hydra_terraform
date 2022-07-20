locals {
  golang_codedir_local_path          = "${path.module}/lambdas/cmd/api_facede"
  golang_binary_local_path           = "${path.module}/lambdas/bin/api_facede"
  golang_zip_local_path              = "${path.module}/lambdas/archive/api_facede.zip"
  golang_zip_base64sha256_local_path = "${local.golang_zip_local_path}.base64sha256"
  golang_zip_s3_key                  = "archive/api_facede.zip"
  golang_zip_base64sha256_s3_key     = "${local.golang_zip_s3_key}.base64sha256.txt"
}
