Docker Dynamic DNS Client
=====

Docker Hub: https://hub.docker.com/r/dfsf5263/docker-dynamic-dns/

GitHub: https://github.com/dfsf5263/docker-dynamic-dns

Original Author's GitHub: https://github.com/blaize/docker-dynamic-dns

A quick fork of the above repo to add support for DynuDNS. May send a PR at some point.

```
docker build --no-cache --tag docker-dynamic-dns .
```

Or you can pull it:

```
docker pull dfsf5263/docker-dynamic-dns
```

To use the image, use Docker run.

```
docker run -it --rm --name no-ip1 -e USER=username -e PASSWORD=yourpassword -e SERVICE=duckdns -e HOSTNAME=example.com -e DETECTIP=1 -e INTERVAL=1 docker-dynamic-dns
```

The envitonmental variables are as follows:

* **USER**: the username for the service.

* **PASSWORD**: the password or token for the service.

* **HOSTNAME**: The host name that you are updating. ie. example.com

* **DETECTIP**: If this is set to 1, then the script will detect the external IP of the service on which the container is running, such as the external IP of your DSL or cable modem.

* **IP**: if DETECTIP is not set, you can specify an IP address.

* **INTERVAL**: How often the script should call the update services in minutes.

* **SERVICE**: The service you are using. Currently, the script is setup to use Google Domains (google), DuckDNS (duckdns), DynDNS (dyndns), and NO-IP (noip). Set the service to the value in parenthesis.

 That's it. Please comment below if there are other services using the DynDNS protocol you would like me to add.
