# Load test with scaling

export OPENFAAS_URL=http://127.0.0.1:31112
hey -z=5s -q 5 -c 2 -m POST -d=Test $OPENFAAS_URL/function/nodeinfo
kubectl scale --replicas=0 deploy/nodeinfo -n openfaas-fn
kubectl scale --replicas=10 deploy/nodeinfo -n openfaas-fn
kubectl --context "kind-kind" rollout status deploy/nodeinfo -n openfaas-fn --timeout=4m
hey -z=5s -q 5 -c 2 -m POST -d=Test $OPENFAAS_URL/function/nodeinfo
kubectl scale --replicas=0 deploy/nodeinfo -n openfaas-fn