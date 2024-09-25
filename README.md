# Hyperleadge Besu 

Este projeto tem como objetivo descrever as etapas para o processo de execução de uma rede [Hperleadge Besu](https://besu.hyperledger.org/en/stable/) utlizando o protocolo de consenso [IBFT 2.0](https://besu.hyperledger.org/en/stable/private-networks/how-to/configure/consensus/ibft/?h=ibft+config)


### Versions
-  `Docker 23.0.1`
-  `Docker Compose 2.15.1`


## Docker

Antes de começar, certifique-se de que o Docker esteja instalado em sua máquina. Você pode fazer o download do Docker aqui: https://docs.docker.com/engine/install/.

O Docker Compose é uma ferramenta útil para executar aplicativos Docker multi-container. Com um arquivo YAML simples, você pode definir e executar vários serviços facilmente. Neste contexto cada container será um nó da rede [Hperleadge Besu](https://besu.hyperledger.org/en/stable/)

## Estrutura de pasta

O projeto possui a seguinte estrutura de pasta:

```
IBFT-Network/
|
├── docker-compose.yml
├── Dockerfile
├── .env.example
├── genesis.json
└── scripts
|   ├── configNetwork.sh
|   ├── defineValidator.sh
|   ├── generateKeys.sh
|   ├── ibftConfigFile.json
|   ├── ibftConfigGenKey.json
|   └── run.sh


```

#### É possível observar os seguintes arquivos:



| Nome   | Tipo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `docker-compose`      | `yml` |  Definir e executa os serviços necessário para o pleno funcionamento da aplicação. 

A aplicação em qustão possúi 5 serviços sendo eles:

  - **config-network**: Responsável pela configuração e criação do arquivo `genesis.json` caso a variável de ambiente *GENERATE_GENESSIS_FILE* esteja definida como true. Para essa operação é levado em consideração os parametros definidos no arquivo `scirpts/ibftConfigFile.json`

  - **node(1,2,3,4)**: Sendo os nós em si. esses serviços são responsáveis por executar o hyperledger besu e estabelecer uma conexão P2P entre eles. 
    *(Observação)* 
        - O protocolo de consenso IBFT 2.0 requer no mínimo 4 nós para manter a rede operante, garantindo a segurança e a confiabilidade das transações. Isso permite que haja um quórum mínimo para a validação e consenso das transações na rede, evitando a possibilidade de ataques ou manipulações por um número muito reduzido de participantes.

| Nome   | Tipo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `DockerFile`      | `yml` |  Contém instruções para definir etapas de construção da imagem que o docker deve realizar, como instalação de  dependências e execução dos comandos. |

| Nome   | Tipo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `.env.example`      | `env` | Contém modelos necessário para configurar as variáveis de ambiente do projeto. |

Este arquivo não é utilizado para a definição das variáveis de ambiente. Mas tem como objetivo orientar quais as variavéis devel ser incluidas no arquivo `.env` ou definidas no ambiente onde a aplicação está sendo executada. sendo elas:

    NODE_HOST_HTTP= <Address http node>
    NODE_HOST_P2P= <Address P2P node>
    GENERATE_VALIDATOR= <Generate Keys ? (boolean)>
    GENERATE_GENESSIS_FILE= <Generate Genesis file ? (boolean)>

| Nome   | Exemplo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `NODE_HOST_HTTP`      | `127.0.0.1:32945` |   endereço de conexão http cujo todos os nós deveram se conectar. (caso você deseje levantar o ambiente da rede main garantindo os 4 nós primarios para o funcionamento você deve deve prencher essa informação com IP:PORT do nó 1.) |


| Nome   | Exemplo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `NODE_HOST_P2P`      | `127.0.0.1:62945` |   esse campo deverá ser preenchido seguindo o exemplo a cima do http host, porém contendo as informações de conexão P2P|

***Observação*** Informações de porta poderão ser consultadas e manipuladas atravéz do arquivo `docker-compose.yaml`.


| Nome   | Exemplo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `GENERATE_VALIDATOR`      | `true` |   para que os nós da rede sejem definidos como validadores a variavel em questão deverá ser definica como true. Validadores são participantes da rede blockchain responsáveis por verificar e validar transações, garantindo a segurança e integridade do sistema. |

***Observação*** *Caso você deseje levantar o ambiente da rede main garantindo os 4 nós primarios para o correto funcionamento você deve deve prencher essa informação true. na primera vêz que iniar os serviços (Você pode prencher como `false` após isso.*

| Nome   | Exemplo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `GENERATE_GENESIS_FILE`      | `true` |   Responsável pela configuração e criação do arquivo `genesis.json` caso a variável de ambiente  esteja definida como true. Para essa operação é levado em consideração os parametros definidos no arquivo `scirpts/ibftConfigFile.json.` |

***Observação*** *Caso seje gerado um novo arquivo genesis,  os dados da rede serão perdidos. portando é importando após a primeira inicialização definir a variável como `false`.*


| Nome   | Tipo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `genesis`      | `json` |   arquivo genesis define propriedades específicas para IBFT 2.0. |



Caso seja necessário criar um novo arquivo genesis para rede, será preciso informar no arquivo `scirpts/ibftConfigFile` as propriedades específicas. As propriedades específicas do IBFT 2.0 são:

  - blockperiodseconds- O tempo mínimo de bloqueio, em segundos.

  - epochlength- O número de blocos após o qual redefinir todos os votos.

  - requesttimeoutseconds- O tempo limite para cada rodada de consenso antes de uma mudança de rodada, em segundos.

  - blockreward- Valor de recompensa opcional em Wei para recompensar o beneficiário. O padrão é zero (0). Pode ser especificado como um valor de string hexadecimal (com prefixo 0x) ou decimal. Se definido, todos os nós da rede devem usar o valor idêntico.

  - miningbeneficiary- Beneficiário opcional do blockreward. O padrão é o validador que propõe o bloco. Se definido, todos os nós da rede devem usar o mesmo beneficiário.

  - extraData- Dados extras codificados por RLP .


| Nome   | Tipo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `scirpts`      | `pasta` |   pasta em qustão possui os script necessários para configuração e execução da rede. |




## Execução dos containers

Para executar o arquivo docker-compose.yml, navegue até o diretório que contém o arquivo e execute o seguinte comando:

```
docker-compose up
```

Para executar os serviços em segundo plano, use a opção -d:

```
docker-compose up -d
```