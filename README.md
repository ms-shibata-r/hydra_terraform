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
    --task <task id> \
    --container hydra \
    --interactive \
    --command "hydra clients create --endpoint <endpoint>:4445/ --id my-client --secret secret --grant-types client_credentials"


aws ecs execute-command \
    --cluster hydra_ecs_cluster \
    --task <task id> \
    --container hydra \
    --interactive \
    --command "hydra token client --endpoint <endpoint>:4444/ --client-id my-client --client-secret secret"


aws ecs execute-command \
    --cluster hydra_ecs_cluster \
    --task <task id> \
    --container hydra \
    --interactive \
    --command "hydra token introspect --endpoint <endpoint>:4445/ <上記コマンドで出力されたトークン>"


aws ecs execute-command \
    --cluster hydra_ecs_cluster \
    --task <task id> \
    --container hydra \
    --interactive \
    --command "hydra clients create \
    --endpoint <endpoint>:4445 \
    --id sample-app-client \
    --secret sample-app-secret \
    --grant-types authorization_code,refresh_token,client_credentials,implicit \
    --response-types token,code,id_token \
    --scope openid,offline \
    --callbacks <対象 URL>"

--------

aws ecs execute-command \
    --cluster hydra_ecs_cluster \
    --task <task id> \
    --container hydra \
    --interactive \
    --command "/bin/sh"
