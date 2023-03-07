#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./../helper

@test "Deploy app" {
    info
    deploy() {
        apply katalog/tests/test-app
        sleep 10
        kubectl exec -it deployment/mysql -- touch /var/lib/mysql/HELLO_CI

    }
    run deploy
    [ "$status" -eq 0 ]
}

@test "Trigger backup" {
    info
    backup() {
        timeout 120 velero backup create backup-e2e-app --from-schedule manifests -n kube-system --wait
    }
    run backup
    [ "$status" -eq 0 ]
}

@test "Verify that backup is completed" {
    info
    verify() {
        velero -n kube-system backup get backup-e2e-app | grep Completed
    }
    loop_it verify 10 10
    [ "$status" -eq 0 ]
}

@test "oops. Chaos...." {
    info
    chaos() {
        kubectl exec -it deployment/mysql -- rm /var/lib/mysql/HELLO_CI
        kubectl delete deployments -n default --all
        kubectl delete pvc -n default --all
        kubectl delete pv mysql-pv
        sleep 15
    }
    run chaos
    [ "$status" -eq 0 ]
}

@test "Restore backup" {
    info
    backup() {
        # Caveat, to restore a `local` pv, the pv must be manually created, restic expects dynamic pv creation
        kubectl apply -n default -f katalog/tests/test-app/resources/pv.yaml
        timeout 120 velero restore create --from-backup backup-e2e-app -n kube-system --wait
    }
    run backup
    [ "$status" -eq 0 ]
}


@test "Test Recovery that deleted files are present" {
    info
    test() {
        kubectl exec -it -n default deployment/mysql -- ls /var/lib/mysql/HELLO_CI
    }
    loop_it test 10 10
    [ "$status" -eq 0 ]
}

@test "Delete backup" {
    info
    delete(){
        velero backup delete backup-e2e-app --confirm -n kube-system
    }
    run delete
    [ "$status" -eq 0 ]
}