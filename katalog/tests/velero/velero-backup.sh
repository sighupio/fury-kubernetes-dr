#!/usr/bin/env bats

load ./../helper


# apk add curl
# curl -Ls -o velero.tar.gz https://github.com/vmware-tanzu/velero/releases/download/v1.2.0/velero-v1.2.0-linux-amd64.tar.gz
# tar -zxf velero.tar.gz
# mv velero*/velero /usr/local/bin/velero
@test "Trigger backup" {
    info
    backup() {
        velero backup create backup-e2e --from-schedule manifests -n kube-system --wait
    }
    run backup
    [ "$status" -eq 0 ]
}

@test "upps. Chaos...." {
    info
    chaos() {
        kubectl delete service velero -n kube-system
    }
    run chaos
    [ "$status" -eq 0 ]
}

@test "Restore backup" {
    info
    backup() {
        velero restore create --from-backup backup-e2e -n kube-system --wait
    }
    run backup
    [ "$status" -eq 0 ]
}


@test "Test Recovery" {
    info
    test() {
        kubectl get service velero -n kube-system
    }
    run test
    [ "$status" -eq 0 ]
}
