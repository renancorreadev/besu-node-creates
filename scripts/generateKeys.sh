## This script generate the validation keys for the current directory

# Generate keys
besu operator generate-blockchain-config --config-file=ibftConfigGenKey.json --to=$(echo network-keys-$NAME_NODE) --private-key-file-name=key

# Move keys to current directory
nodekey=$(find $(echo network-keys-$NAME_NODE)/ -type f -name "*key.pub") && mv $nodekey /var/lib/besu

nodekey=$(find $(echo network-keys-$NAME_NODE)/ -type f -name "*key") && mv $nodekey /var/lib/besu

# Delete folder `networkKeys`
rm -r $(echo network-keys-$NAME_NODE)
