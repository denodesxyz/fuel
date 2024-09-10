# Fuel
[Fuel](https://x.com/fuel_network) is an operating system purpose-built for Ethereum Rollups. Fuel allows rollups to solve for PSI (parallelization, state minimized execution, interoperability) without making any sacrifices. Further information can be found on Fuel's [website](https://fuel.network/).

## Installation
By running your own [Fuel node](https://docs.fuel.network/guides/running-a-node/), you can execute a higher number of queries without rate limits and gain full control over your interactions on the Fuel blockchain.

### prerequisites
- CPU: **2 Cores**
- Memory: **4 GB RAM**
- Disk: **200 GB SSD**
- Machine: **Ubuntu 22.04+**

### sepolia api key
Before running a node you should have a sepolia api key which you can optain from any rpc provider such as [Alchemy](https://www.alchemy.com/) or [Infura](https://www.infura.io/). Please ensure you're using the correct endpoints for the Sepolia network. Otherwise, your node may fail to start.

### script execution
Run the script to install the node. When prompted, enter "y" to proceed.
```
wget -O fuel.sh https://api.denodes.xyz/fuel.sh && bash fuel.sh
```

### p2p key
During installation, the script generates a p2p key. This key is crucial for your node's operation and network identification. Be sure to securely back it up and keep it confidential!

## Useful Commands
- View your node details:
```
curl -X POST http://0.0.0.0:4000/v1/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ chainInfo: chain { latestBlock { id height } chainName: name } systemHealth: health nodeDetails: nodeInfo { peers { peerId: id } version: nodeVersion } }"}' \
```

- Restart your node:
```
systemctl restart fueld
```

- View your node logs:
```
journalctl -fu fueld -o cat
```

- Delete your node:
```
systemctl stop fueld
systemctl disable fueld
rm /etc/systemd/system/fueld.service
rm -rf $HOME/.fuel
rm -rf $HOME/.fuelup
rm -rf $HOME/.forc
rm $HOME/fuel.sh
```
