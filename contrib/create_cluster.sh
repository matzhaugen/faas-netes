#!/usr/bin/env bash
set -o errexit
DEVENV=${OF_DEV_ENV:-kind}
KUBE_VERSION=v1.18.8
REG_NAME=kind-registry
REG_PORT=5000

./contrib/create_local_registry.sh ${REG_NAME} ${REG_PORT}
echo ">>> Creating Kubernetes ${KUBE_VERSION} cluster ${DEVENV}"

# create a cluster with the local registry enabled in containerd
cat <<EOF | kind create cluster \
--wait 5m --image kindest/node:${KUBE_VERSION} --name "$DEVENV" -v 1 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${REG_PORT}"]
    endpoint = ["http://${REG_NAME}:${REG_PORT}"]
EOF


# connect the registry to the cluster network
# (the network may already be connected)
containers=$(docker network inspect kind -f "{{range .Containers}}{{.Name}} {{end}}")
needs_connect="true"
for c in $containers; do
  if [ "$c" = "${reg_name}" ]; then
    needs_connect="false"
  fi
done
if [ "${needs_connect}" = "true" ]; then               
  docker network connect "kind" "${REG_NAME}" || true
else
	echo ">>> Kind network already connected to local registry"
fi


echo ">>> Waiting for CoreDNS"
kubectl --context "kind-$DEVENV" -n kube-system rollout status deployment/coredns
