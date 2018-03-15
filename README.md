# Docker Image for Vertcoin Insight
[![Docker Pulls](https://img.shields.io/docker/pulls/jamesl22/insight-vtc.svg)](https://hub.docker.com/r/jamesl22/insight-vtc/)

## Quickstart
You can run the image directly using the ```docker run``` command.

The vertcore node will download the full blockchain which can take several hours, so you may want to mount the image's ```/data``` directory to a volume so that the data can be persisted when the node is restarted.

The following commands will persist data into ```~/.vertcore``` on the host machine:

```bash
$ docker run -v "~/.vertcore:/data" jamesl22/insight-vtc
```

### Configuration
The image will automatically create a default configuration file in the mounted ```/data``` directory. To make it easier to configure the node yourself you may want to directly mount the included ```vertcore-node.json``` file:
```bash
$ docker run -v "~/.vertcore:/data" -v "$(pwd)/vertcore-node.json:/data/vertcore-node.json" jamesl22/insight-vtc
```

If you want to run a testnet node you can mount the provided testnet configuration file instead:
```bash
$ docker run -v "~/.vertcore:/data" -v "$(pwd)/vertcore-node-testnet.json:/data/vertcore-node.json" jamesl22/insight-vtc
```

If you choose note to mount the ```vertcore-node.json``` file then you will have to manually edit the file from your mounted ```/data``` directory.

## Swarm Mode
The provided ```docker-compose-*``` files can be used to run a Vertcoin Insight node in swarm mode. There are three different variants:

| variant | compose file names | description |
|-|-|-|
| basic | ```docker-compose.yml```<br>```docker-compose-testnet.yml``` | A basic Insight node. |
| vcoin | ```docker-compose-vcoin.yml```<br>```docker-compose-vcoin-testnet.yml``` | Enables support for scaling to multiple Insight node instances, using [traefik](https://traefik.io/) as the loader balancer. |
| vertcoin | ```docker-compose-vertcoind.yml```<br>```docker-compose-vertcoind-testnet.yml``` | Enables support for scaling to multiple Insight node instances, using [traefik](https://traefik.io/) as the loader balancer. Also uses a shared ```vertcoind``` node to reduce the resources needed for each Insight node. |

Select the configuration you want to use and deploy using the following commands:
```bash
$ docker swarm init
$ docker stack deploy -c docker-compose-vertcoind.yml insight
```

Each variant includes a ```*-testnet.yml``` file. Deploy this configuration if you want your node to run against the test network.

## Building
This image has been published under the name ```jamesl22/insight-vtc```. You can build your own image using the ```docker build``` command:

```bash
$ docker build -t insight-vtc .
```

## Known Issues
### "Network mismatch" error after switching network
When switching a running node between live and test network you may need to delete the ```chain.ldb``` directory in the mounted ```/data``` volume. You may also wish to delete ```vertcorenode.db``` to reclaim disk space.

### Permission error writing to ```/data``` volume
When using ```docker run``` to run Insight you may need to ensure that the ```vertcore``` user has permission to write to the directory you have mounted to ```/data```. The ```vertcore``` user has a fixed UID of 9000 so you can use the following commands to prepare a suitable ```~/.vertcore``` directory:
```bash
$ mkdir ~/.vertcore
$ chown 9000 ~/.vertcore
```
