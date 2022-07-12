#!/bin/bash

# Let's do some checks
if (! docker stats --no-stream &> /dev/null ); then
  echo "You must have docker installed and kubernetes turned on"
  exit 1
fi
if (! command -v brew &> /dev/null ); then
  echo "You must have homebrew installed"
  exit 1
fi
if (! command -v terraform &> /dev/null ); then
  echo "You must install terraform"
  exit 1
fi
if (! command -v pip &> /dev/null ); then
  echo "You must install python 3 and pip"
  exit 1
fi

pip install -e requirements.txt

terraform init
terraform plan
terraform apply --auto-approve

open http://localhost:4566/restapis/3rcfgtcwez/test/_user_request_/graphql

# for resolver in ./resolvers/{clients,studies,subjects,sites,visits,forms}/service.yaml; do
#     dir=`dirname $resolver`
#     file=`basename $resolver`
#     funcName=`basename $dir`
#     pushd $dir &> /dev/null
#     echo "DIR: ${dir} FILE: ${file} FUNC: $funcName"
#     docker build -t isterin/knative-${funcName}-resolver .
#     docker push isterin/knative-${funcName}-resolver
#     kn service delete knative-${funcName}-resolver
#     kubectl apply --force --filename ./${file}
#     kubectl get ksvc knative-${funcName}-resolver --output=custom-columns=NAME:.metadata.name,URL:.status.url
#     popd &> /dev/null
# done