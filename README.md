# Local Services Setup

> A generic setup for web development based on Docker including reverse proxy
> for local domains.

This branch does not support TLS (SSL).
See branches `tls/letsencrypt` and `tls/mkcert` for possible approaches.

## Installation

The services are deployed as Docker containers. Follow these steps to install the
environment:

1. Run `10-install-docker.sh` with your usual non-elevated privileges.
The script will ask for the sudo password.
It removes outdated versions of Docker, if any, and installs the latest version.
`dnsmasq` is added as a DNS server to catch local domains and route them to 127.0.0.1. 


2. Copy `.env-dist` to `.env` and modify the copy to your needs.


3. Run `20-prepare-host.sh` to configure the network settings according to your settings
in the `.env` file.

After completing these steps, start the environment with

```shell
docker-compose up -d
```

You'll find the dashboard of **Traefik**, the reverse proxy and load balancer, at
`http://traefik.your-local-domain/dashboard/`
and **Portainer**, the graphical user interface for Docker and
Kybernetes management at
`http://portainer.your-local-domain`.

## Optional Services

### Source Code Management: Gitea

```bash
source .env && docker-compose -f gitea.yml up -d
```

`http://git.your-local-domain`

### Content Management: Joomla

```bash
source .env && docker-compose -f joomla.yml up -d
```

`http://joomla.your-local-domain`

## Environment


```dotenv
# Set your email address here, is for the generation of SSL certificates with Let's Encrypt.
CERT_EMAIL=your-email

# The location for the certificates (not used)
CA_STORE=/usr/local/share/ca-certificates

# The master password of your browser, used to access the NSS database
BROWSER_PASSWORD=your-browsers-master-password

# The domain you want to use
DOMAIN=local.mydomain
```

## Reverse Proxy: Traefik

`http://traefik.your-local-domain/dashboard/`

## Container Management: Portainer

`http://portainer.your-local-domain`

## Adding a new Service

Any service that is supposed to be accessible through Traefik must connect to the
`traefik` network.

```yaml
networks:
  traefik:
    name: traefik
    external: true

services:
  myservice:
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik"
    networks:
      - traefik
```

If a service consists of more than one container, all those containers should be
connected by an internal network.

```yaml
networks:
  myinternalnet:
    name: myinternalnet
    internal: true

services:
  myservice:
    links:
      - "myinternalservice:expectedservice"
    networks:
      - myinternalnet

  myinternalservice:
    networks:
      - myinternalnet
```

The complete example:

```yaml
networks:
  traefik:
    name: traefik
    external: true
  myinternalnet:
    name: myinternalnet
    internal: true

services:
  myservice:
    links:
      - "myinternalservice:expectedservice"
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik"
    networks:
      - traefik
      - myinternalnet

  myinternalservice:
    networks:
      - myinternalnet
```
