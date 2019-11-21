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

# remove haproaxy components
eval ${kubectl} --kubeconfig ${kubeconfig} delete service -n monitoring prometheus-service
eval ${kubectl} --kubeconfig ${kubeconfig} delete deployment -n monitoring prometheus-deployment
eval ${kubectl} --kubeconfig ${kubeconfig} delete configmap -n monitoring prometheus-server-conf
eval ${kubectl} --kubeconfig ${kubeconfig} delete ClusterRoleBinding -n monitoring prometheus
eval ${kubectl} --kubeconfig ${kubeconfig} delete ClusterRole -n monitoring prometheus
eval ${kubectl} --kubeconfig ${kubeconfig} delete namespace -n monitoring monitoring
