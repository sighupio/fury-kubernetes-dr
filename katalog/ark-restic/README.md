# Ark Restic

Ark Restic is an Ark deployment with [restic](https://restic.net/) support for Kubernetes volumes backup and restore. Using restic in combination with Ark becomes necessary when volume snapshotting is not provided. This is very useful for backup of glusterfs persistent volumes

## Requirements

- Kubernetes >= `1.10.0`
- Kustomize >= `v1`
- [prometheus-operator](https://github.com/sighup-io/fury-kubernetes-monitoring/blob/master/prometheus-operator)

## Image repository and tag

* Ark Restic image: `gcr.io/heptio-images/ark:v0.9.10`
* Ark Restic repo: https://github.com/heptio/ark 

## Configuration

Fury distribution Ark Restic is deployed with following configuration:

- Deployed as Daemonset
- Metrics are scraped by Prometheus every `30s`

## Deployment

You can deploy Ark Restic by running following command in the root of the project:

`$ kustomize build | kubectl apply -f -`


## License

For license details please see [LICENSE](https://sighup.io/fury/license) 
