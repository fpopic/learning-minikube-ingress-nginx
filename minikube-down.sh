#!/bin/bash

set -euo pipefail

kubectl delete -f web/1.namespace
minikube addons disable ingrees
minikube stop
