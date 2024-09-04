#!/bin/bash

RED="\e[31m"
NOCOLOR="\e[0m"

curl -s https://api.denodes.xyz/logo.sh | bash && sleep 1
echo ""
echo "Welcome to the Fuel One-Liner Script! 🛠

Our goal is to simplify the process of running a Fuel node.
"
echo ""

cd $HOME

touch $HOME/.bash_profile
source $HOME/.bash_profile

curl https://install.fuel.network | sh
PATH="$HOME/.fuelup/bin:$PATH"
source $HOME/.bashrc

echo ""
read -rsn1 -p"Press any key to generate the private key. You’ll need this key in the next step"; echo

fuel-core-keygen new --key-type peering

echo ""

read -p 'Enter the private key from the "secret" field: ' P2P_SECRET
echo "export P2P_SECRET="$P2P_SECRET"" >> $HOME/.bash_profile

read -p "Enter the Sepolia RPC: " SEPOLIA_RPC
echo "export SEPOLIA_RPC="$SEPOLIA_RPC"" >> $HOME/.bash_profile

source $HOME/.bash_profile

mkdir $HOME/.fuel
cd $HOME/.fuel
wget -O chain_config.json https://github.com/FuelLabs/chain-configuration/raw/master/ignition/chain_config.json
wget -O metadata.json https://github.com/FuelLabs/chain-configuration/raw/master/ignition/metadata.json
wget -O state_config.json https://github.com/FuelLabs/chain-configuration/raw/master/ignition/state_config.json
wget -O state_transition_bytecode.wasm https://github.com/FuelLabs/chain-configuration/raw/master/ignition/state_transition_bytecode.wasm

cd $HOME
sudo tee /etc/systemd/system/fueld.service > /dev/null <<EOF
[Unit]
Description=fueld

[Service]
Type=simple
User=root
ExecStart=$(which fuel-core) run \
  --service-name fuel-sepolia-testnet-node \
  --keypair $P2P_SECRET \
  --relayer $SEPOLIA_RPC \
  --ip=0.0.0.0 --port=4000 --peering-port=30333 \
  --db-path=~/.fuel \
  --snapshot ~/.fuel \
  --utxo-validation --poa-instant false --enable-p2p \
  --reserved-nodes /dns4/p2p-testnet.fuel.network/tcp/30333/p2p/16Uiu2HAmDxoChB7AheKNvCVpD4PHJwuDGn8rifMBEHmEynGHvHrf \
  --sync-header-batch-size 100 \
  --enable-relayer \
  --relayer-v2-listening-contracts=0x01855B78C1f8868DE70e84507ec735983bf262dA \
  --relayer-da-deploy-height=5827607 \
  --relayer-log-page-size=500 \
  --sync-block-stream-buffer-size 30
Restart=on-failture
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=fueld
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable fueld
systemctl restart fueld
journalctl -fu fueld -o cat
