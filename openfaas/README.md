## Setup

1. Install Docker Desktop and enable Kubernetes
2. Execute `./setup.sh` script

Add two environmental variables
```
export OPENFAAS_URL=http://127.0.0.1:31112
export PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
```
** You can set these in your typical .zshrc or similar profile file.  We recommend using `direnv` for development.  You can create a file `.envrc` in your project dir and set the above variables, which will apply when you're inside the directory.

## Add a function
This will be done in the resolvers directory

```
$ cd resolvers
# This will pull the latest templates from the OpenFaaS repo.
$ faas-cli template pull 

# You can also use the "template store" command to get more templates
$ faas-cli template store list
$ faas-cli template store pull ruby-http

# Now we can create a new function using an existing template we pulled down.  You can use any template as a parameter to --lang
$ faas-cli new func-name --lang ruby-http
```

## Deploy the function
First let's login to our OpenFaaS cluster

`$ faas-cli login --password $PASSWORD `

Now we'll deploy the function

`$ faas-cli deploy -f func-name.yml`
