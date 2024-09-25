##  Este script é responsavel por fazer a start do nó
##  bem como obter parametros necessários para conexão com o nó alvo

# Verifica se existe um genesis file
while [ $(cat $BESU_GENESIS_FILE) = "{}" ]; do
    echo await $BESU_GENESIS_FILE ...
    sleep 2
done

# Realiza a geração do enode do nó alvo para estabelecer conexão P2P
if [ "$GENERATE_ENODE" = "true" ]; then
    $CONNECTION
    # Verifica se existe uma conexão com a api
    while [ -v $CONNECTION ]; do
        CONNECTION=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' $(echo $NODE_HOST_HTTP))
        echo $CONNECTION
        sleep 2
    done

    # Faz a chamada da API JSON-RPC e extrai a parte anterior ao símbolo @ do valor da propriedade enode
    enode=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"net_enode","params":[],"id":1}' $(echo $NODE_HOST_HTTP) | jq -r '.result' | cut -d "@" -f1)

    # Concatena a string @NODE_HOST_P2P ao final do valor da variável enode
    enode="${enode}@$(echo $NODE_HOST_P2P)"

    # Exporta a variavel @BESU_BOOTNODES para o container
    export BESU_BOOTNODES="${enode}"

fi

# Gera as chaves de validação caso necessário
if ! [ "$GENERATE_GENESIS_FILE" = "true" ] && [ "$GENERATE_VALIDATOR" = "true" ]; then
    echo gerando validador
    bash generateKeys.sh

    # Define o nó como validador
    bash defineValidator.sh &
fi

# Start Hyperleadge Besu
besu
