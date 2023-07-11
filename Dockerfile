# Use Ubuntu 20.04 as base image
FROM ubuntu:20.04

# Set timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Istanbul /etc/localtime

# Update packages and Install prerequisites
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libicu66 \
    libssl1.0 \
    libunwind8 \
    netcat \
    software-properties-common \
    lsb-release \
    tzdata \
    sudo \
    apt-transport-https \
    gnupg-agent && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    apt-get update

# Install Docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

# Install Azure Pipelines Agent
WORKDIR /azp
COPY ./start.sh .
RUN chmod +x start.sh && \
    curl -LsS https://vstsagentpackage.azureedge.net/agent/3.220.5/vsts-agent-linux-arm64-3.220.5.tar.gz -o agent.tar.gz && \
    tar -zxvf agent.tar.gz && \
    rm -rf agent.tar.gz

CMD ["./start.sh"]
