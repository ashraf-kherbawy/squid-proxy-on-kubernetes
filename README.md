# Squid Proxy on Kubernetes

This repository was built to provide a ready to go Squid Proxy deployment in Kubernetes. 

## Dockerfile

The Dockerfile in this repository is the one I used to deploy my squid. It's a very simple Dockerfile without too many configurations. I uploaded the image to Dockerhub at ashrafkh99/ashrafk-squid-proxy:1.0, but if you want to use your own repository, you will need to build the image on your side, tag it and then push it:

Run docker build:
```
docker build -t squid .
```

Tag image:
```
docker tag squid:latest YOUR-NAMESPACE/YOUR-REPO:TAG
```

Then finally push the image:
```
docker push YOUR-NAMESPACE/YOUR-REPO:TAG
```

## Squid full Deployment

The ful deployment file consists of 3 different Kubernetes resources:

    - ConfigMap
    - Deployment
    - Service

### Squid ConfigMap

The ConfigMap contains an example of a Squid config file, which contains the important rules that you need to pass. Here is the example used:

```
http_port 3128
acl localnet src 0.0.0.1-0.255.255.255
acl domain_dst dst OVERRIDE-WITH-IP
acl domain_port port OVERRIDE-WITH-PORT
http_access allow localnet
http_access allow domain_dst 
http_access deny all
```

The above configuration specifies the following:

    - http_port 3128: Squid will run on port 3128.
    - acl localnet src: Define all IP addresses with variable 'localnet'.
    - acl domain_dst dst OVERRIDE-WITH-IP: Define a destination that Squid can route to with variable 'domain_dst'.
    - acl domain_port port OVERRIDE: Define the destination's port with variable 'domain_port'.
    - http_access allow localnet: Allow 'localnet' which is all IP addresses to go through Squid on HTTP.
    - http_access allow domain_dst: Allow 'domain_dst' which is the destination IP, to be reached through Squid.
    - http_access deny all: Deny all other destinations.

**NOTE**: Squid's dst is only made to work with IP addresses. If you need to route to a domain, use dstdomain instead. I recommend checking Squid's [Access Control List's doc](https://wiki.squid-cache.org/SquidFaq/SquidAcl#access-controls-in-squid) for more information

### Squid Deployment 

The Squid deployment contains basic configurations to run the container on port 3128, with one replica, and mount the ConfigMap to etc/squid/conf.d/. The command section goes as the following:
```
  command:
    - "squid"
    - "-NYCd"
    - "1"
    - "-f"
    - "/etc/squid/conf.d/squid.conf"
```
The above command basically tells Squid to use the squid.conf file as specified in the path.

### Squid Service

Regular ClusterIP service for internal communications only in the Kubernetes cluster. If for whatever reason you need an app to go through Squid when it's outside the cluster, consider using a LoadBalancer service instead.
