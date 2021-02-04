# Local Services Setup

> A generic setup for web development based on Docker including reverse proxy
> and TLS (SSL) for local domains.

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
The script installs a local Certification Authority (CA) in your system trust store
as well as in the Firefox and/or Chrome/Chromium trust store and creates certificates
for your domain, its subdomains and localhost (including 127.0.0.1 and :::1). 

After completing these steps, start the environment with

```shell
docker-compose up -d
```

You'll find the dashboard of **Traefik**, the reverse proxy and load balancer, at
`https://traefik.your-local-domain/dashboard/`
and **Portainer**, the graphical user interface for Docker and
Kybernetes management at
`https://portainer.your-local-domain`.

## Environment


```dotenv
# Set your email address here, is for the generation of SSL certificates with Let's Encrypt.
CERT_EMAIL=your-email

# The location for the certificates
CA_STORE=/usr/local/share/ca-certificates

# The master password of your browser, used to access the NSS database
BROWSER_PASSWORD=your-browsers-master-password

# The domain you want to use
DOMAIN=local.mydomain
```

## Reverse Proxy: Traefik

`https://traefik.your-local-domain/dashboard/`

## Container Management: Portainer

`https://portainer.your-local-domain`

## Certificate Management: mkcert, Let's Encrypt
