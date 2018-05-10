#!/bin/bash

# If there is no current context, get one.
echo "current config:"
kubectl config current-context

echo "Running: fission $(kubectl --namespace fission get svc router -o=jsonpath='{..ip}') $@"
/usr/local/bin/fission --server $(kubectl --namespace fission get svc router -o=jsonpath='{..ip}') "$@"

