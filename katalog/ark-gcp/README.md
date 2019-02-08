# Velero on GCP

the only thing missing from this deployment is the `sa.json` service account key to be added to the `cloud-credentials` secret in the `kube-system` namespace. we'll do this with kustomize secretGenetor