#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./../helper

@test "Trigger backup" {
    info
    backup() {
        timeout 120 velero backup create backup-e2e --from-schedule manifests -n kube-system --wait
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
        timeout 120 velero restore create --from-backup backup-e2e -n kube-system --wait
    }
    run backup
    [ "$status" -eq 0 ]
}


@test "Test Recovery" {
    info
    test() {
        kubectl get service velero -n kube-system
    }
    loop_it test 10 10
    [ "$status" -eq 0 ]
}

@test "Delete backup" {
    info
    delete(){
        velero backup delete backup-e2e --confirm -n kube-system
    }
    run delete
    [ "$status" -eq 0 ]
}