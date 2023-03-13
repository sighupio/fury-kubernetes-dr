#!/usr/bin/env bats
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2154

load ./../helper

@test "Applying Monitoring" {
    info
    kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v2.0.0/katalog/prometheus-operator/crds/0prometheusruleCustomResourceDefinition.yaml
    kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v2.0.0/katalog/prometheus-operator/crds/0servicemonitorCustomResourceDefinition.yaml
}

@test "Deploy Velero on Prem" {
    info
    test() {
        apply katalog/velero/velero-on-prem
    }
    loop_it test 30 10
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}

@test "Velero is Running" {
    info
    test() {
        kubectl get pods -l k8s-app=velero -o json -n kube-system |jq '.items[].status.containerStatuses[].ready' | uniq | grep -q true
    }
    loop_it test 60 10
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}

@test "Deploy Velero Restic" {
    info
    test() {
        apply katalog/velero/velero-restic
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Velero Restic is Running" {
    info
    test() {
        kubectl get pods -l k8s-app=velero-restic -o json -n kube-system |jq '.items[].status.containerStatuses[].ready' | uniq | grep -q true
    }
    loop_it test 60 5
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}

@test "Deploy Velero Schedules" {
    info
    test() {
        apply katalog/velero/velero-schedules
    }
    run test
    [ "$status" -eq 0 ]
}

@test "check minio setup job" {
  info
  test(){
    data=$(kubectl get job -n kube-system -l k8s-app=minio-setup -o json | jq '.items[] | select(.metadata.name == "minio-setup" and .status.succeeded == 1 )')
    if [ "${data}" == "" ]; then return 1; fi
  }
  loop_it test 400 6
  status=${loop_it_result}
  [[ "$status" -eq 0 ]]
}