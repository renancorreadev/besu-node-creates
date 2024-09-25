## Este script é responsável por gerar arquivos de configurações necessários para o funcionamento da rede

# Generate genesis file
if [ "$GENERATE_GENESIS_FILE" = "true" ]; then
    # Define genesis file como {}
    echo "{}" >$BESU_GENESIS_FILE

    # Generate keys
    besu operator generate-blockchain-config --config-file=ibftConfigFile.json --to=network-keys-$NAME_NODE --private-key-file-name=key

    # Move keys to node directory
    index=0
    for folder in "/app/network-keys-$NAME_NODE/keys"/*/; do
        ((index++))
        rm -r /data/node$index && mkdir /data/node$index
        cp $(echo ${folder}key) $(echo /data/node$index) && cp $(echo ${folder}key.pub) $(echo /data/node$index)
    done

    # Define novo genesis file
    echo $(cat network-keys-$NAME_NODE/genesis.json) >$BESU_GENESIS_FILE

    rm -r $(echo network-keys-$NAME_NODE)
fi
