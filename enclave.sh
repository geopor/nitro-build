#!/bin/sh

function restart_vsock_proxy() {
  REGION=$2
  PORT=$3
  : ${REGION:="ap-northeast-2"}
  : ${PORT:="8001"}

  killall vsock-proxy -q
  nohup vsock-proxy $PORT kms.$REGION.amazonaws.com 443 &
}

function console_print() {
  sudo nitro-cli describe-enclaves | jq '.[0].EnclaveID' | xargs nitro-cli console --enclave-id
}

if [ $1 = "docker" ]; then
  DOCKER_USER=$2
  : ${DOCKER_USER:="tearust"}
  sudo docker rmi $DOCKER_USER/runtime:nitro
  sudo nitro-cli build-enclave --docker-uri $DOCKER_USER/runtime:nitro --output-file enclave_app.eif
  echo "current docker images:"
  sudo docker images
elif [ $1 = "debug" ]; then
  CONSOLE=$2
  : ${CONSOLE:=""}

  restart_vsock_proxy
  sudo nitro-cli run-enclave --eif-path enclave_app.eif --cpu-count 2 --enclave-cid 6 --memory 1024 --debug-mode
  if [ $CONSOLE = "on" ]; then
    console_print
  fi
elif [ $1 = "run" ]; then
  restart_vsock_proxy
  sudo nitro-cli run-enclave --eif-path enclave_app.eif --cpu-count 2 --enclave-cid 6 --memory 1024
elif [ $1 = "list" ]; then
  sudo nitro-cli describe-enclaves | jq
elif [ $1 = "clean" ]; then
  sudo nitro-cli describe-enclaves | jq '.[0].EnclaveID' | xargs nitro-cli terminate-enclave --enclave-id
elif [ $1 = "console" ]; then
  console_print
elif [ $1 = "client" ]; then
  sudo docker-compose down
  sudo docker rmi tearust/parent-instance-client:nitro
  sudo docker-compose up
elif [ $1 = "proxy" ]; then
  restart_vsock_proxy
else
  echo "unknown command. Supported subcommand: docker, debug, run, list, clean, console, client, proxy"
fi