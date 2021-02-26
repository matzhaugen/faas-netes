# Load test with scaling

FXN_NAME=echo
export OPENFAAS_URL=http://127.0.0.1:31112
hey -z=5s -q 5 -c 2 -m POST -d=Test $OPENFAAS_URL/function/$FXN_NAME # All should give 200
sleep 5
kubectl scale --replicas=0 deploy/$FXN_NAME -n openfaas-fn
kubectl scale --replicas=1 deploy/$FXN_NAME -n openfaas-fn
kubectl --context "kind-kind" rollout status deploy/$FXN_NAME -n openfaas-fn --timeout=4m
hey -z=5s -q 5 -c 2 -m POST -d=Test $OPENFAAS_URL/async-function/$FXN_NAME
kubectl scale --replicas=0 deploy/$FXN_NAME -n openfaas-fn 