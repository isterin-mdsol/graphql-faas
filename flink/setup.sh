#!/bin/bash

# kubectl create -f application-module.yaml
kubectl create -f flink-config.yaml
kubectl create -f jobmanager-service.yaml

kubectl create -f jobmanager-job.yaml
kubectl create -f jobmanager-rest-service.yaml
kubectl create -f taskmanager-job-deployment.yaml