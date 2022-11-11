# Use case 4
In this use case we will make our helm deployment more dynamic by adding helper templates to switch configuration.
A common scenario would be to switch between `test` and `prod` environments.
Depending on your security requirements, in a `test` environment it can be okay to use passwords from kubernetes secrets and storing them as `base64` string in some version control. 
So developers can deploy and test things with more ease.
But moving to a production environment this is not good practise anymore. 
Vault for example, helps you by capsuling multiple kinds of security topics in a single application. 
In this use case we want to get in touch with password management in vault injected by a side-car container.

* A) Prerequisites
  * Before implementing and testing this use case you need to create a vault instance und add some default configuration to it
  * Find the necessary [manual here](PREREQUISITES.md)
* B) [Dynamic helm with vault](#a-dynamic-helm-with-vault)
  * Add a parameter to [values.yaml](helm/values.yaml) that can be used to switch between different deployments

## A) Dynamic helm with vault
By adding the following helpers the required switching can be achieved:
* [app/helper.tpl](helm/templates/app/_helper.tpl)
  * Manages secrets mounted by volumes
* [db/helper.tpl](helm/templates/db/_helper.tpl)
  * Manages database initiation script 
* [secret/helper.tpl](helm/templates/secret/_helper.tpl)
  * Manage volumes containing secrets, annotations to mount secrets from vault and the service account used by vault
```bash
# get the helm chart
git clone --single-branch --branch usecase/v4 https://github.com/Haagy/from-zero-to-k8s.git usecase-v4

# install or upgrade with helm
helm upgrade --install --create-namespace --namespace usecase-v4 usecase-v4 usecase-v4/helm/
```

Wait until all resources are in ready state. This can take a few minutes.
```bash
kubectl --namespace=usecase-v4 get all
```
When all applications are initialized you can test them by:
```bash
# get service port
export SERVICE_PORT=$(kubectl get service/usecase-v4-app-service \
                        --output=go-template='{{(index .spec.ports 0).nodePort}}' \
                        --namespace=usecase-v4 )

# check database status
curl localhost:$SERVICE_PORT/get-values

# should return
## Table [rest_api_table] contains no values
##
## Add some by calling [<SERVICE_NAME>:<SERVICE_PORT>/write/<VALUE>]

# add some values
curl -X POST localhost:$SERVICE_PORT/write/first
curl -X POST localhost:$SERVICE_PORT/write/something-else

# check database status
curl localhost:$SERVICE_PORT/get-values

# should return
## Table [rest_api_table] contains the following values:
##
## Value: first
## Value: something-else
```

## Next steps
With more and more individual applications getting deployed to one or different clusters, it gets more and more challenging managing configuration the applications need to interact with each other.
Like authorization, authentication, routing or secure communication.
Vault for example helps you to achieve the first two.

In [use case 5](https://github.com/Haagy/from-zero-to-k8s/tree/usecase/v5) we will make our helm deployment more dynamic and add the possibility to switch between for example dev and prod mode.


## Playing around
Try changing `environment.isProd` to `false` and deploy this helm chart again in a different namespace.
It should also work as expected just with the difference, that the password used to initialize the database comes from [values.yaml](helm/values.yaml) (`db.pasword: asdfasdf`).
You could do that in a single command as well:
```bash
# checkout repo
git clone --single-branch --branch usecase/v4 https://github.com/Haagy/from-zero-to-k8s.git usecase-v4-dev

# deploy helm chart
helm upgrade --install \
  --set=environment.isProd=false \
  --create-namespace \
  --namespace usecase-v4-dev \
  usecase-v4-dev usecase-v4/helm/
```
Find some other ways to interact with vault [here](https://helm.sh/docs/chart_best_practices/conventions/).
