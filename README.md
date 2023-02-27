# Learning K8s

This is my attempt at learning Kubernetes.

**Goals**:

- [x] Containerize a simple Flask application
- [x] Use `terraform` to create a [kind](https://kind.sigs.k8s.io/) cluster and install [MetalLB](https://metallb.org/) on it
- [x] Create `Deployment`, `Service` and `ConfigMap` manifest files for the app
- [x] Use [kustomize](https://kustomize.io/) to customize the manifest files and deploy the app
- [x] Use `terraform` to deploy [Argo CD](https://github.com/argoproj/argo-cd/)
- [x] Deploy the application using a combination of `Argo CD` and `kustomize`

> Credits to [DevOps Journey](https://github.com/devopsjourney1) and their [tutorial video](https://www.youtube.com/watch?v=1Lu1F94exhU) for the application and the manifest files!

# How to

Build a container image containing the application:

```sh
docker build app -t chzerv/flask-app
```

Create the cluster, load the container image on it and install `MetalLB`:

```sh
cd terraform-kind
terraform apply -var image=chzerv/flask-app
cd ..
```

## Deploy the app

Using `kustomize`, deploying the application is as simple as running:

```sh
kubectl kustomize -k app/manifests
```

Using `Argo CD`, which leverages `kustomize`:

```sh
kubectl apply -f app/manifests/application.yaml
```
