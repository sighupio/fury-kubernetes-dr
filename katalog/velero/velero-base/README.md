# Velero Base

This directory contains common components needed to deploy Velero.

## Common components

- [CRDs](./crds.yaml)
- [Base Velero deployment](./deployment.yaml)
- [RBAC](./rbac.yaml)
- [Manifest backup Schedule definition](./schedule.yaml)
- [Velero metrics service](./service.yaml)
- [Velero ServiceMonitor](./serviceMonitor.yaml)

## Important

This directory does not provide any functionality by itself. Please refer to the different Velero deployment options:

- [Velero On Prem](../velero-on-prem/README.md)
- [Velero AWS](../velero-aws/README.md)
- [Velero GCP](../velero-gcp/README.md)
- [Velero Azure](../velero-azure/README.md)

These deployments uses this base to deploy velero configured for each cloud provider.
