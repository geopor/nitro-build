#!/bin/sh

source ~/.env

ENCLAVE_CID=6 \
	NITRO_PROXY_PORT=8001 \
	AWS_REGION=$AWS_REGION \
	NITRO_KEY_ID=$NITRO_KEY_ID \
	LAYER1_WS_PROVIDER_URL=$LAYER1_WS_PROVIDER_URL \
	GENESIS_CONFIG_PATH=genesis.json \
	LAYER1_KEY_PATH=.layer1/key \
	LASTEST_TOPUP_HEIGHT=8313477 \
	TEA_ID=$TEA_ID \
	MACHINE_OWNER=$MACHINE_OWNER \
	LIBP2P_BOOTNODES=$LIBP2P_BOOTNODES \
	LIBP2P_NODE_KEY_PATH=.libp2p/key \
	LIBP2P_ENABLE_RELAY_PEERS="true" \
	LIBP2P_SUPPORTED_PROTOCOLS=tea-0.14 \
	LIBP2P_AGENT_PROTOCOL=tea-0.14 \
	LIBP2P_VERSION=0.14 \
	STATE_MAGIC_NUMBER=200 \
	APPLY_VALIDATOR="true" \
	PERSIST_PATH=.tokenstate/persist \
	RUST_BACKTRACE=full \
	MALLOC_CONF="prof:true" \
	./client-runner