#!/bin/bash

# Let's do some checks
if (! docker stats --no-stream &> /dev/null ); then
  echo "You must have docker installed and kubernetes turned on"
  exit 1
fi
if (! kubectl cluster-info &> /dev/null ); then
  echo "You must enable kubernetes in your Docker Desktop (or run it in some other way)"
  exit 1
fi
if (! command -v brew &> /dev/null ); then
  echo "You must have homebrew installed"
  exit 1
fi
if (! command -v kind &> /dev/null ); then
  brew install kind
fi
if (! command -v kn &> /dev/null ); then
  brew install knative/client/kn
  brew install knative-sandbox/kn-plugins/quickstart
  kn quickstart kind
fi

for resolver in ./resolvers/{clients,studies,subjects}/service.yaml; do
    dir=`dirname $resolver`
    file=`basename $resolver`
    funcName=`basename $dir`
    pushd $dir &> /dev/null
    echo "DIR: ${dir} FILE: ${file} FUNC: $funcName"
    docker build -t isterin/knative-${funcName}-resolver .
    docker push isterin/knative-${funcName}-resolver
    kubectl apply --filename ./${file}
    kubectl get ksvc knative-${funcName}-resolver --output=custom-columns=NAME:.metadata.name,URL:.status.url
    popd &> /dev/null
done