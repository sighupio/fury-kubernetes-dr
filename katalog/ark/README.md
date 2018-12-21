# Ark Katalog

Ark is a tool to backup and restore Kubernetes cluster resources and persistent volumes. This package deploys Ark on AWS.

## Requirements

- Kubernetes >= `1.10.0`
- Kustomize >= `v1`
- [prometheus-operator](https://github.com/sighup-io/fury-kubernetes-monitoring/blob/master/prometheus-operator)


## Image repository and tag

* Ark image: `gcr.io/heptio-images/ark:v0.9.10`
* Ark repo: https://github.com/heptio/ark 


## Configuration

Fury distribution Ark is deployed with following configuration:

- Replica number : `1`
- Runs on AWS
- Metrics are scraped by Prometheus every `30s`


## Deployment

You can deploy Ark by running following command in the root of the project:

`$ kustomize build | kubectl apply -f -`


## License

For license details please see [LICENSE](https://sighup.io/fury/license) 
