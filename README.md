# Use case 2
Our application starts growing more and more. We want to improve our application and need to persist our data.
Therefore, we need to create:
* A) [Configurations](#a-configurations)
  * Add a Secret used in app and database deployment
  * Create a ConfigMap containing information needed for the database connection
  * Add an initiation script for the database
* B) A [Volume](#b-volumes) where data is getting persisted
  * Create PersistentVolume 
  * Create PersistentVolumeClaim 
* C) Another [Deployment](#c-database-deployment) and update existing 
  * Create a database Deployment and update
  * Update existing

## A) Configurations
* [Secrets](k8s/db/config/vars.yml) hide sensitive data as Base64 encoded string.
* ConfigMaps can be used to add [multiple configuration variables](k8s/db/config/vars.yml).
* ConfigMaps can also be used to store files like [database init script](k8s/db/config/init-db.sql)

Run the following commands
```bash
# secret
kubectl create --filename https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/usecase/v2/k8s/db/config/secret.yml

# common vars
kubectl create --filename=https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/usecase/v2/k8s/db/config/vars.yml

# init script
curl -O https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/usecase/v2/k8s/db/config/init-db.sql
kubectl create configmap init-db.sql --from-file=init-db.sql
```

## B) Volumes
Volumes persist data in different ways. 
One that we are using [here](k8s/db/volume/pv.yml) is on local storage that retains data even if the Pod is getting destroyed.
But before Kubernetes decides on which Node database with PersistentVolume is getting deployed we need to [request for storage](k8s/db/volume/pvc.yml).
```bash
kubectl create --filename https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/usecase/v2/k8s/db/volume/pv.yml
kubectl create --filename https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/usecase/v2/k8s/db/volume/pvc.yml
```

## C) Database Deployment
All resources created above are included in the deployment files:
```bash
# create database deployment and service
kubectl create --filename https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/usecase/v2/k8s/db/deployment.yml
kubectl create --filename https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/usecase/v2/k8s/db/svc.yml

# apply changes to the python rest application
kubectl apply --filename https://raw.githubusercontent.com/Haagy/from-zero-to-k8s/usecase/v2/k8s/app/deployment.yml
```

To connect the python rest api to the database we add the name of the database Service as environment variable to [application deployment](k8s/app/deployment.yml)
```yaml
env:
  - name: POSTGRES_HOST
    value: db-service
```

## Next steps
Now we can persist data that our application is creating.
But what if we want to deploy it in another cluster. 
We would need to execute every single file to do so. That is not really handy. 
In [use case 3](https://github.com/Haagy/from-zero-to-k8s/tree/usecase/v3) we want to have a look at how to package up Kubernetes files.
There we are getting familiar with helm charts.


## Playing around
Here you can adjust some configuration files and deploy the resource files again. 
Or try deploying a different database and connect it with the rest application. 