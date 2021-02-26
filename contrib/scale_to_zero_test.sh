# Load test with scaling

export OPENFAAS_URL=http://127.0.0.1:31112
# Start with a fresh slate to emulate scale to zero
kubectl scale --replicas=0 deploy/echo -n openfaas-fn
sleep 11

# Start request batch #1
curl -X POST -d Test $OPENFAAS_URL/function/echo # scale to 1
hey -z=2s -q 5 -c 2 -m POST -d Test $OPENFAAS_URL/function/echo
sleep 5 # Necessary to not get 404
# Scale back to zero
kubectl scale --replicas=0 deploy/echo -n openfaas-fn
# sleep 5
# Start request batch #2
hey -z=2s -q 5 -c 2 -m POST -d Test $OPENFAAS_URL/function/echo # gives 404