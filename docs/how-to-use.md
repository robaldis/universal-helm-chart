# Unviersal Helm chart

To use the universal helm chart you can mostly get by with the simple example 
and build of off that. This takes in an container image and a port number to expose
to an ingress with storage and environment variables can be defined too. 

```yaml
deployments:
  application:  # name of the application
    # image
    image: nginx
    tag: 1.14.2

    # this is the port that the application uses
    port: 80

    # Environment variables, key vaule paid, key being the name of the environment
    # variable used by the application
    env: 
      key: value

    
    storage:
      main: # name the storage, Nothing can have the same name in the namespace
        class: longhorn # only been tested with longhorn
        path: /data #Path in the container
        capacity: 1G

    # Ingress to access the application using tls certificates
    ingress: 
      url: nginx.your_url.com
      cert_env: staging
```

There are some more complicated scenarios that require us to think more about 
kubernetes and how resources work that change the deployment.

## Multiple deployments

When an application has dependencies we can define all the dependencies in the 
same file and they all will be deployed, only thing that you need to be careful
of is that some resources in the same namespace cannot have the same name. 
Universal helm chart will try to handle for this but it is possible to cause 
problems when the same value for a resource is used. It would be best practice
to give descriptive names to resources.

## Requests and limits

It is always good to put requests and limits on resources so the orchestration
of pods can be done more intelegently.

```yaml
deployments:
  application:  # name of the application

    requests:
      cpu: "100m"
      memory: "100Mi"

    limits:
      cpu: "1"
      memory: "1G"
```

## Command

We can run the image with a given command, this is done with an array of strings 
like so.

```yaml

deployments:
  application:  # name of the application

    command: ["ls", "-la", "some/file"]
```


## Don't want ingress?

Just remove the ingress field and the cert and ingress won't be deployed

## HostPath

This is not often used and should only be used if you truly need host path 
storage mappings

This is defined in the storage section as follows

```yaml
deployments:
  application:  # name of the application

    storage:
      proc:
        type: hostPath
        hostPath: /proc
        path: /host/proc
        readOnly: true
        hostPathType: Directory
      sys:
        type: hostPath
        hostPath: /sys
        path: /host/sys
        readOnly: true
        hostPathType: Directory

```

## Daemonset

Sometimes you need a daemon set to run pods an all nodes of the cluster, this
can be done by adding and setting the `type` flag in the application to `daemonset`.

```yaml
deployments:
  application:  # name of the application
    # image
    image: nginx
    tag: 1.14.2
    # this is the port that the application uses
    port: 80
    type: daemonset
```

Valid options for type:
- `daemonset`
- `deployment`

