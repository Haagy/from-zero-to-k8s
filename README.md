# Use case 3
As the application growths incrementally bigger and bigger we need a way to group things together.
In Kubernetes, we can make use of Helm to solve this problem.
* A) [Happy helming](#a-happy-helming)
  * Template all values that are repeated in different files 
  * Add an initiation script for the database

## A) Happy helming
* [Secrets](helm/templates/db/config/vars.yml) hide sensitive data as Base64 encoded string.
* ConfigMaps can be used to add [multiple configuration variables](helm/templates/db/config/vars.yml).

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


## Next steps
Now we can persist data that our application is creating.
But what if we want to deploy it in another cluster. 
We would need to execute every single file to do so. That is not really handy. 
In [use case 4](https://github.com/Haagy/from-zero-to-k8s/tree/usecase/v3) we want to have a look at how to package up Kubernetes files.
There we are getting familiar with helm charts.


## Playing around
Here you can adjust some configuration files and deploy the resource files again. 
Find some best practices [here](https://helm.sh/docs/chart_best_practices/conventions/)