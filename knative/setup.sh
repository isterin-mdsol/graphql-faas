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

brew install kind
brew install knative/client/kn
brew install knative-sandbox/kn-plugins/quickstart
kn quickstart kind
