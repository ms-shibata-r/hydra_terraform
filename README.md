# hydra_terraform

## aws configure設定

https://dev.classmethod.jp/articles/lim-cli-profile/


## Terraform実行
terraform apply


## 手動で実行
・api gateway
GetメソッドにLambda関数再度設定し直し

・Lambda
「api_facede」の設定からデータベースプロキシ選択
「hydra-rds-proxy」が設定されるようにする

・セキュリティーグループ
hydra_rds_sgから「すべてのトラフィック」のインバウンドルール削除

## ターミナルで下記実行
aws ecs execute-command \
    --cluster hydra_ecs_cluster \
    --task 443a4ea271ba4495b7a1b7cefe3773e3 \
    --container hydra \
    --interactive \
    --command "hydra clients create --endpoint http://hydra-aws-lb-f455d424b17eae09.elb.ap-northeast-1.amazonaws.com:4445/ --id my-client --secret secret --grant-types client_credentials"


aws ecs execute-command \
    --cluster hydra_ecs_cluster \
    --task 443a4ea271ba4495b7a1b7cefe3773e3 \
    --container hydra \
    --interactive \
    --command "hydra token client --endpoint http://hydra-aws-lb-f455d424b17eae09.elb.ap-northeast-1.amazonaws.com:4444/ --client-id my-client --client-secret secret"


aws ecs execute-command \
    --cluster hydra_ecs_cluster \
    --task 443a4ea271ba4495b7a1b7cefe3773e3 \
    --container hydra \
    --interactive \
    --command "hydra token introspect --endpoint http://hydra-aws-lb-f455d424b17eae09.elb.ap-northeast-1.amazonaws.com:4445/ m8pyj9ysVA6KA5Iu7m1POuaZVpmQ1OPxYdo0OyZeRR8.6FfZ4lE1mSRrD4PYnX0jQjvd9KUXCgLOCSi0YepgWYw"


aws ecs execute-command \
    --cluster hydra_ecs_cluster \
    --task 443a4ea271ba4495b7a1b7cefe3773e3 \
    --container hydra \
    --interactive \
    --command "hydra clients create \
    --endpoint http://hydra-aws-lb-f455d424b17eae09.elb.ap-northeast-1.amazonaws.com:4445 \
    --id sample-app-client \
    --secret sample-app-secret \
    --grant-types authorization_code,refresh_token,client_credentials,implicit \
    --response-types token,code,id_token \
    --scope openid,offline \
    --callbacks http://127.0.0.1:5000/callback,http://localhost:5000/callback"
