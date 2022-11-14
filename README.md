# Basics 2 (Pods)
In the current status we have one running application in a container runtime. 
But we actually want to deploy this application to a kubernetes cluster.
Before we start playing around let us create our own namespace where all resources created here are grouped
Go to your virtual machine, where you have access to `kubectl`, and run:
```bash
# secret
kubectl create namespace=basics-v2
```

To do so we have to tell kubernetes to run our application in a pod.
```bash
kubectl run python-rest-api \
  --namespace=basics-v2 \
  --image=docker.io/haagy/python-rest-api:1.0 \
  --port=5000
```

To get some information about the running pod you can use:
```bash
# get status of all pods
kubectl get pods --namespace=basics-v2

# get information about a single pod
kubectl describe pod python-rest-api --namespace=basics-v2
```

But working with the command line is not a good way to use kubernetes in a long term. 
A more preferred way is using `yaml`.
As an example, we could achieve the same as above with the file [pod.yml](k8s/pod.yml).
```bash
kubectl create \
  --namespace=basics-v2 \
  --filename=https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/step/v1/k8s/pod.yml
```
But now we also have the ability to add this file in to **Git**, adjust it and trace all changes.
Moreover, kubernetes helps us to create this files by adding the parameters `--dry-run=client` and `--output=yaml`
```bash
kubectl run python-rest-api \
  --namespace=basics-v2 \
  --image=docker.io/haagy/python-rest-api:1.0 \
  --port=5000 \
  --dry-run=client \
  --output=yaml
```
Now we don't have to remember the whole structure.

## Next steps
At this point we actually won nothing except the experience of changing the commands to (nearly) do the same thing.
Worse. We currently are not able to reach the application without further configuration in kubernetes.
In [use case 1](https://github.com/Haagy/from-zero-to-k8s/tree/usecase/v1) we will dig deeper into:
* making the application available
* use one of the main advantages in kubernetes - the ability to scale applications

## Playing around
From here you can play around with pods.
Maybe insert your own image, that you created in [step 0](https://github.com/Haagy/from-zero-to-k8s/tree/step/v0)
