```
localstack start

zip -r9 clients.zip clients.js database.json

awslocal lambda create-function --function-name lambda-clients --runtime nodejs16.x --zip-file fileb://clients.zip --handler clients.handler --role "arn:aws:iam::000000000000:role/graphql"

awslocal lambda update-function-code \
    --function-name lambda-clients \
    --zip-file fileb://clients.zip

awslocal lambda invoke --function-name lambda-clients --cli-binary-format raw-in-base64-out --payload '{"body": {"args": {"id": "1"}}}' /dev/stdout

```

