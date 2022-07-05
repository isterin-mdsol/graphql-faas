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

if (! command -v faas-cli &> /dev/null ); then
  echo "Installing OpenFAAS..."
  brew install faas-cli
fi

if (! command -v arkade &> /dev/null ); then
  echo "Installing Arkade..."
  sudo curl -SLsf https://dl.get-arkade.dev/ | sudo sh
fi


if (! kubectl rollout status -n openfaas deploy/gateway &> /dev/null ); then
  arkade install openfaas
  while ! kubectl rollout status -n openfaas deploy/gateway
  do
    echo "waiting for openfaas to start..."
    sleep 2
  done
fi

# kubectl port-forward -n openfaas svc/gateway 8080:8080 &
OPENFAAS_URL=http://127.0.0.1:31112
PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
echo -n $PASSWORD | faas-cli login --username admin --password-stdin
echo "Your credentials for OpenFAAS gateway: USERNAME: admin PASSWORD: ${PASSWORD}"

echo
echo "Please add this to your shell environment: "
echo "export OPENFAAS_URL=http://127.0.0.1:31112"
echo

echo "Deploying functions"

cd ./resolvers
for dir in ./resolvers; do
    faas-cli template pull
    faas-cli up -f functions.yml
done




