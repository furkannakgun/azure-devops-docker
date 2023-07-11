#!/bin/bash
set -e

export AZP_URL=https://dev.azure.com/furkanakgun81/
export AZP_TOKEN=v6zro72jnndkuppe5xh2cvxczry34npnfnmcvextes6j4c3htzqa
export AZP_AGENT_NAME=azure-devops-agent
export AZP_POOL=azure-devops-agent-pool

if [ -z "$AZP_URL" ]; then
  echo "Error: AZP_URL is not set"
  exit 1
fi

if [ -z "$AZP_TOKEN" ]; then
  echo "Error: AZP_TOKEN is not set"
  exit 1
fi

if [ -z "$AZP_AGENT_NAME" ]; then
  echo "Error: AZP_AGENT_NAME is not set"
  exit 1
fi

if [ -z "$AZP_POOL" ]; then
  echo "Error: AZP_POOL is not set"
  exit 1
fi

# Install QEMU
apt-get update && apt-get install -y qemu-user-static
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# Get the agent
export agenturl=https://vstsagentpackage.azureedge.net/agent/2.186.1/vsts-agent-linux-x64-2.186.1.tar.gz
curl -LsS $agenturl | tar -xz & wait $!

cd vsts-agent-linux-x64-2.186.1

# Configure
./config.sh --unattended --url $AZP_URL --auth pat --token $AZP_TOKEN --pool $AZP_POOL --agent $AZP_AGENT_NAME --replace

# Run
./run.sh
