First, run setup.sh

Now let's set up a function:
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

6. Configure logging https://knative.dev/docs/serving/observability/logging/collecting-logs/#procedure
    kubectl apply -f https://github.com/knative/docs/raw/main/docs/serving/observability/logging/fluent-bit-collector.yaml
    kubectl port-forward --namespace logging service/log-collector 8080:80


kind create cluster --name knative --config kindconfig.yaml
kn quickstart kind 
kubectl apply -f https://github.com/knative/docs/raw/main/docs/serving/observability/logging/fluent-bit-collector.yaml
kubectl apply -f fluent-bit-collector.yaml
kubectl port-forward --namespace logging service/log-collector 8080:80