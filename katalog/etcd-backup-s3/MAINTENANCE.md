# ETCD Backup S3 Maintenance

The manifests that are present inside this package are handcrafted by us: there is no upstream to follow, apart from the `rclone` image.

We're relying on the `snapshot` utility from `etcdctl`, which is basically a wrapper around a gRPC call to
`etcd`, so as long as we keep compatibility with the underlying gRPC call used by the `etcd` server, we're ok.

Long story short, keep an eye on the `etcd` upstream changelog (in k8s and in `etcdctl`) for `etcd`
gRPC API deprecation, in particular check the `Snapshot` interface.

References:
- [https://github.com/etcd-io/etcd/blob/3c916bb2587174008054f629d784514abe9e8d36/client/v3/maintenance.go#L230](client/v3/maintenance.go)
- [https://github.com/etcd-io/etcd/blob/3c916bb2587174008054f629d784514abe9e8d36/api/etcdserverpb/rpc.pb.go#L7549](api/etcdserverpb/rpc.pb.go)

The main logic of the backup and the snapshot is implemented in the `init.sh`
file, in the [`etcd-backupper` image](https://github.com/sighupio/fury-distribution-container-image-sync/tree/main/modules/dr/custom/etcd-backupper).

## Upgrade checklist
In order to update and maintain the package:
- First check if a new image is available for `rclone`
- Check if another version of Alpine or `etcdctl` is available and update the [custom built `etcd-backupper` image](https://github.com/sighupio/fury-distribution-container-image-sync/tree/main/modules/dr/custom/etcd-backupper)
- (Optional) Sync the new rclone image to our registry
- (Optional) Update the images tags in the kustomization.yaml file
- (Optional) Fix manifest deprecations
