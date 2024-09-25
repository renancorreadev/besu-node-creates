if [ "$GENERATE_VALIDATOR" = "true" ]; then
    $CONNECTION
    while [ -v $CONNECTION ]; do
        nodeaddress=$(besu --data-path=$(echo $BESU_DATA_PATH) public-key export-address 2>&1 | grep -oE '0x[0-9a-z]+' | tail -1)
        CONNECTION=$(curl -X POST --data '{"jsonrpc":"2.0","method":"ibft_proposeValidatorVote","params":["'"$nodeaddress"'", true], "id":1}' $(echo $NODE_HOST_HTTP))
        echo $CONNECTION $nodeaddress

        sleep 2
    done
fi
