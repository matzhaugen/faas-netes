# Load test with scaling
DEVENV=${DEVENV:-kind}
export OPENFAAS_URL=http://127.0.0.1:31112
hey -z=5s -q 5 -c 2 -m POST -d=Test $OPENFAAS_URL/async-function/sleep
hey -z=5s -q 5 -c 2 -m POST -d=Test $OPENFAAS_URL/function/sleep
