# ETCD Backup S3 Maintenance

The manifests that are present inside this package are handcrafted by us: there is no upstream to follow, apart from the various images.

In order to update and maintain the package:
- First check if new images are available for `etcd` and `rclone`
- Update the images tags
- Sync the image to our registry
