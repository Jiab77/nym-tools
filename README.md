# nym-tools

Basic scripts and tools for the Nym network

## Goal

This project has been made initialy to provide an easy way to deploy a __[Nym](https://nymtech.net/)__ *open proxy* to allow those with restricted internet access to browse or let their applications to connect to an existing deployed proxy. More features will be added in next releases.

__*The project itself is still experimental and don't provide support for [custom gateways](https://nymtech.net/docs/stable/run-nym-nodes/nodes/gateways/) yet.*__

## Supported platforms

* __Server__
  * Tested on __Ubuntu Server__ 20.04.x
* __Client__
  * Tested on __Pop!\_OS__ 20.04.x

> Should work on any __Ubuntu__ 20.04.x based clients.

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

#### Configure applications

Once the client service is running, you can configure your applications to use your local __Nym__ `SOCKS5` client.

##### Chromium Browser

Unlike [Tor](https://www.torproject.org/), [Nym](https://nymtech.net/) is not really made web for anonymous web browsing so even if it works, __expect it to be crazily slow!__

* With user profile + Incognito mode:

```console
$ chromium-browser --new-window --incognito --proxy-server="socks5://localhost:1080" https://example.com
```

* No user profile + Incognito mode:

```console
$ chromium-browser --temp-profile --new-window --incognito --proxy-server="socks5://localhost:1080" https://example.com
```

##### Telegram Desktop

Go to __Settings__ -> __Advanced__ -> __Connection type__ then apply the following settings:

![image](https://user-images.githubusercontent.com/9881407/200093669-a380e123-d67a-4c6a-a286-ba752daea372.png)

Click on __Save__ to finish.

> I haven't tested calls within the proxy yet so please let me know if you tried with the option __Use proxy for calls__ checked and it worked.

You should see this icon at the bottom left when enabled:

![image](https://user-images.githubusercontent.com/9881407/200096295-9a45bd73-7dcc-4db9-bf54-eadc67bdb3a5.png)

##### Proxychains

To configure __proxychains__ to use your local __Nym__ `SOCKS5` client, you simply add a new line in the file `/etc/proxychains.conf`:

```
socks5         127.0.0.1 1080
```

Make sure to not have __Tor__ enabled in same time by commenting the line:

```
# socks5         127.0.0.1 9050
```

> You should be able to use several proxies with __proxychains__ but for simplicity I prefer use one single unique proxy. I might explain later how to make it work with several proxies.

You can also run the following commands for patching the config file:

```bash
# Disable existing socks proxies
sudo sed -e 's/socks4 /# socks4 /' -e 's/# # socks4 /# socks4 /' -e 's/socks5 /# socks5 /' -e 's/# # socks5 /# socks5 /' -i /etc/proxychains.conf

# Enable Nym socks5 client proxy
echo "socks5  127.0.0.1 1080" | sudo tee -a /etc/proxychains.conf
```

Now you can test if it worked. Here are some example commands / uses:

* With `nmap`

```console
$ sudo proxychains4 -q nmap -A -vv -sS example.com
```

* With `testssl.sh`

```console
$ cd testssl.sh-3.0.5/
$ sudo proxychains4 -q ./testssl.sh https://example.com
```

* With `w3m`

```console
$ sudo proxychains4 -q w3m https://example.com
```

> Very slow but works.

##### Curl

```console
$ curl -x "socks5://localhost:1080" https://example.com
```

##### Wappalyzer

```console
$ wappalyzer --pretty --proxy "socks5://localhost:1080" https://example.com
```

## Credits

* [@jiab77](https://github.com/Jiab77) - Project
* [@hackerschoice](https://github.com/hackerschoice) - Support
