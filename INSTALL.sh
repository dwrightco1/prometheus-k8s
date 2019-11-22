#!/bin/bash

usage() {
    echo "Usage: $(basename $0) <path-to-kubectl> <path-to-kubeconfig>"
    exit 1
}

assert() {
  echo "FATAL: ${1}"
  exit 1
}

# validate required args
if [ $# -ne 2 ]; then usage; fi
kubectl=${1}
kubeconfig=${2}

# valaidate kubectl/kubeconfig
if [ ! -r ${kubectl} ]; then assert "missing kubectl: ${kubectl}"; fi
if [ ! -r ${kubeconfig} ]; then assert "missing kubeconfig: ${kubeconfig}"; fi

# install
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f prometheus-namespace.yaml -n monitoring
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f prometheus-clusterrole.yaml -n monitoring
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f prometheus-configmap.yaml -n monitoring
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f prometheus-deployment.yaml -n monitoring
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f prometheus-service.yaml -n monitoring

# install alert manager
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f alertManager-configmap.yaml -n monitoring
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f alertTemplate-configmap.yaml -n monitoring
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f alertManager-deployment.yaml -n monitoring
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f alertManager-service.yaml -n monitoring

# install grafana
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f grafana-datasource-config.yaml
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f grafana-deployment.yaml
eval ${kubectl} --kubeconfig ${kubeconfig} apply -f grafana-service.yaml
