#!/usr/bin/env bats
# shellcheck disable=SC2154

load ./../helper

@test "Applying Monitoring" {
    info
    kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v1.3.0/katalog/prometheus-operator/crd-servicemonitor.yml
    kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v1.3.0/katalog/prometheus-operator/crd-rule.yml
}

@test "Deploy Velero Base" {
    info
    deploy() {
        apply katalog/velero/velero-base
    }
    run deploy
    [ "$status" -eq 0 ]
}

@test "Deploy Velero on Prem" {
    info
    deploy() {
        apply katalog/velero/velero-on-prem
    }
    run deploy
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
    deploy() {
        apply katalog/velero/velero-restic
    }
    run deploy
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
    deploy() {
        apply katalog/velero/velero-schedules
    }
    run deploy
    [ "$status" -eq 0 ]
}