# Step 3
In this lecture we want to learn more about Services and how to connect multiple applications

## Use case
* A) We will release our first application as a [proof of concept](#deploy-application-as-proof-of-concept) on Kubernetes
* B) We will make the [application available for our customers](#available-for-customers)
* C) The customers tested our application and added some feature requests. 
Our deployment team implemented these requirements. Let us [update our application](#updating-an-application).

## Deploy application as proof of concept
A Deployment is used to manage a set of Pods.
Without a Deployment, we need to create, update, and delete all pods manually.

Let us turn our single Pod into a Deployment.
Run the following command to create a Deployment from [file](k8s/deployment.yml):
```bash
kubectl create --filename https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/step/v2/k8s/deployment.yml
```
This will create three objects:
* The Pod where our application is running
* A *ReplicaSet* which manages, how many instances of our application should run
* And a Deployment which handles the update process for this application

That can be displayed with:
```bash
kubectl get all
```

## Available for customers
Services enable network access Pods in Kubernetes.
Services select Pods based on their labels.
There are multiple types of Services that can be used. 
[Here](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0) is good article explaining the differences.
In this tutorial we use the type `LoadBalancer`

Run the following command to create a *Service* from [file](k8s/service.yml)
```bash
kubectl create --filename https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/step/v2/k8s/service.yml
```

Now we are able to call the api via curl:
```bash
# get service port
export SERVICE_PORT=$(kubectl get services/python-rest-api --output=go-template='{{(index .spec.ports 0).nodePort}}')

# curl on main node
curl localhost:$SERVICE_PORT
```

## Updating an application
Let us update the Deployment. 
In [deployment-improved.yml](k8s/deployment-improved.yml) we updated `image: docker.io/haagy/python-rest-api:1.1` and set `replicas: 4`.
The changes to the image are, that the application should now return `Hello! Greetings from Pod: <HOSTNAME>`.
<HOSTNAME> represents the name where the application is running in (mostly a hashed value)
Let us apply this changes and see what is happening:
```bash
kubectl apply --filename https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/step/v2/k8s/deployment-improved.yml
```
If you are quick enough with:
```bash
kubectl get all
```
you will notice, that the old Pod is in state `Terminating` und 4 new Pods are created.

If you now execute the curl command a few times different outputs are displayed.
```bash
# get service port
export SERVICE_PORT=$(kubectl get services/python-rest-api --output=go-template='{{(index .spec.ports 0).nodePort}}')

# curl on main node
curl localhost:$SERVICE_PORT
```


The outputs will match the output from as Kubernetes created those Pods with these names.
```bash
kubectl get pods
```

## Next steps
New we have a running application that can be called from outside our cluster.
In [step 2](https://github.com/Haagy/from-zero-to-k8s/tree/step/v2) we want to have a look at how extend our application more and how to connect it with other applications.


## Playing around
At this point you are able to play with your Deployment.
You could change the DeploymentStrategy and see how one differs from the other.
Have a look at [here](https://blog.container-solutions.com/kubernetes-deployment-strategies) for more information about strategies.
