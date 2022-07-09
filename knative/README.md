Running `setup.sh` will install everything you need and the functions.

## Creating a new function

Details instructions: https://github.com/knative/docs/tree/main/code-samples/serving/hello-world/helloworld-nodejs

1. Clone one of hello world apps as a template
    git clone https://github.com/knative/docs.git knative-docs
    cp -R knative-docs/code-samples/serving/hello-world/helloworld-nodejs clients

2. Make changes to service and update service.yaml
3. Build and push docker file:
    docker build -t isterin/knative-clients-resolver .
    docker push isterin/knative-clients-resolver

4. Deploy with kubectl
    kubectl apply --filename service.yaml

5. Get function URL:
    kubectl get ksvc knative-clients-resolver --output=custom-columns=NAME:.metadata.name,URL:.status.url

## Tailing the logs

Currently, setting up logging in knative ia brain numbing activity.  KNative automatically scales the function containers as needed. The containers scale down to 0 if it's not used for a minute or so.  This is all configurable, but much harder when using the quickstart template.  For now, if something doesn't work when you invoke a function and you need to debug, you can quickly run this command:

`> kubectl get pods -A | grep PartOfTheNameOfYourFunction`

This will give you the id of the container, which you can then use to tail the logs

`> kubectl logs -f name-of-the-conatainer-from-above-1234`

Remember, these commands will only work within a minute after executing the function, since that's when KNative will create the container and keep it alive for a minute or so.  To keep the container alive, you just keep invoking it every 30 seconds or so while tailing the log.

Sorry, I ran out of time in figuring out how to get quickstart local env to not scale functions down to 0 or how to better aggregate logs.