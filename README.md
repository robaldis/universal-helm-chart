# Universal Helm Chart

# DO NOT USE
> There are some defaults and magic strings in the templates that are specific to 
> my environment. This will not work for you... yet.

This helm chart lays out a basic setup to deploy to a kubernetes cluster through 
helm with the ease of writing a single yaml file. I tried to make it as easy as 
possible to take a docker compose and port to this helm chart.

Why use this helm chart rather than the specified ones for the application?
The idea for this chart is to make something similar to docker compose format to
make it as easy as possible to deploy new containers to a cluster. Most home-lab
applications are made to be run easily through docker or docker-compose. Helm 
charts for a lot of applications do exist, but they can vary a lot in how they 
are used, What values mean what. This is simplifying things, so its easy to 
manage kubernetes deployments.

Simplicity must be losing out on functionality?
Well, yes, at the moment there are some things that you can't do
- resource limits and requests
- secrets 
- different storage class (only been tested with longhorn)
- complicated ingress rules where different paths go to different services
I do plan on looking into those limitations and fixing them. Currently, it's good 
enough for simple deployments.

Basic yaml to deploy 1 service:
```yaml
deployments:
  application:  # name of the application
    # image
    image: nginx
    tag: 1.14.2
    port: 80 # this is the port that the application uses

    env: 
      key: value

    storage:
      main: # name the storage, Nothing can have the same name in the namespace
        class: longhorn # only been tested with longhorn
        path: /data #Path in the container
        capacity: 1G

    ingress: 
      url: nginx.your_url.com
      cert_env: staging
```

```bash
 wget https://github.com/robaldis/universal-helm-chart/archive/refs/tags/v-0.1-alpha.zip && unzip -j v-0.1-alpha.zip
 "universal-helm-chart-v-0.1-alpha/chart/*" -d chart && rm v-0.1-alpha.zip
```
