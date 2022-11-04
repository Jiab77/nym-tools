# nym-tools

Basic scripts and tools for the Nym network

## Goal

This project has been made initialy to provide an easy way to deploy a __[Nym](https://nymtech.net/)__ *open proxy* to allow those with restricted internet access to browse or let their applications to connect to an existing deployed proxy. More features will be added in next releases.

__*The project itself is still experimental and don't provide support for [custom gateways](https://nymtech.net/docs/stable/run-nym-nodes/nodes/gateways/) yet.*__

## Supported components

* __Server__
  * [nym-client](https://nymtech.net/docs/stable/integrations/websocket-client/)
  * [nym-network-requester](https://nymtech.net/docs/stable/run-nym-nodes/nodes/requester/)
* __Client__
  * [nym-socks5-client](https://nymtech.net/docs/stable/integrations/socks5-client/)

## Usage

Clone the project:

```console
$ git clone https://github.com/Jiab77/nym-tools.git
```

Get binaries with the [related](get-binaries.sh) script:

```console
$ cd nym-tools
$ ./get-binaries.sh
```

## Open proxy

### Server

This section is only required for those who want to deploy their own __Nym__ *open proxy* server.

__*You must initialize the binaries before using them.*__

#### Initialize

To initialize the [nym-client](https://nymtech.net/docs/stable/integrations/websocket-client/) and the [nym-network-requester](https://nymtech.net/docs/stable/run-nym-nodes/nodes/requester/) you can run the [init-server.sh](init-server.sh) script that way:

```console
$ cd ~/nym-tools
$ ./init-server.sh
```

> __The script assume that you've created a dedicated `nym` user.__
>
> You can specify another user by adding `--user <username>` as argument.

#### Run services

To run the [nym-client](https://nymtech.net/docs/stable/integrations/websocket-client/) and the [nym-network-requester](https://nymtech.net/docs/stable/run-nym-nodes/nodes/requester/) services you can use the provided `install-service.sh` scripts that way:

```console
$ cd ~/nym-tools
$ sudo ./nym-client/install-service.sh
$ sudo ./nym-network-requester/install-service.sh
```

> __The script assume that you've created a dedicated `nym` user.__
>
> You can specify another user by adding `--user <username>` as argument.

### Client

This section is only required for those who want to connect their apps to an existing __Nym__ *open proxy* server.

__*You must initialize the binaries before using them.*__

#### Initialize

To initialize the [nym-socks5-client](https://nymtech.net/docs/stable/integrations/socks5-client/) you can run the [init-client.sh](init-client.sh) with the __provider__ address of your own server or another one script that way:

```console
$ cd ~/nym-tools
$ ./init-client.sh --provider <client-address-from-server>
```

> __The script assume that you've created a dedicated `nym` user.__
>
> You can specify another user by adding `--user <username>` as argument.

#### Run service

To run the [nym-socks5-client](https://nymtech.net/docs/stable/integrations/socks5-client/) you can use the provided `install-service.sh` script that way:

```console
$ cd ~/nym-tools
$ sudo ./nym-socks5-client/install-service.sh
```

> __The script assume that you've created a dedicated `nym` user.__
>
> You can specify another user by adding `--user <username>` as argument.

## Credits

* @jiab77 - Project
* @hackerschoice - Support
