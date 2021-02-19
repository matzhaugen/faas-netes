# create registry container unless it already exists
REG_NAME=${1:-kind-registry}
REG_PORT=${2:-5000}
running="$(docker inspect -f '{{.State.Running}}' "${REG_NAME}" 2>/dev/null || false)"
if [ "${running}" != 'true' ]; then
  docker run \
    -d --restart=always -p "127.0.0.1:${REG_PORT}:5000" --name "${REG_NAME}" \
    registry:2
fi