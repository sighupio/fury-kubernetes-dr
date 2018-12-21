# Ark Restic Backup Configuration

This example shows how to configure ark-restic for backups. Example includes configuration for backup storage provider and backup policy. 

0. Run furyctl to get packages: `$ furyctl install --dev`

In `ark-backup.yml` file:

1. Replace `backupStorageProvider` details  in `Config` resource to match your storage configuration. 

2. Modify `Schedule` resource for your desired backup policy. You can exclude/include cluster resources and namespaces.

When you're configuration is in place:

3. Run `make build` to see output of kustomize with your modifications.

4. Once you're satisfied with generated output run `make deploy` to deploy it on your cluster.
