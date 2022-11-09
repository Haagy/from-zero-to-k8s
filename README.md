# Use case 3
As the application growths incrementally bigger and bigger we need a way to group things together.
In Kubernetes, we can make use of Helm to solve this problem.
* A) [Happy helming](#a-happy-helming)
  * Template all values that are repeated in different files

## A) Happy helming
With all resources templated as variables the whole deployment can be executed with two commands:
```bash
# get the helm chart
git clone --single-branch --branch usecase/v3 https://github.com/Haagy/from-zero-to-k8s.git usecase-v3

# install or upgrade with helm
helm upgrade --install --create-namespace --namespace usecase-v3 usecase-v3 usecase-v3/helm/
```

Wait until all resources are in ready state. This can take a few minutes.
```bash
kubectl --namespace=usecase-v3 get all
```
When all applications are initialized you can test them by:
```bash
# get service port
export SERVICE_PORT=$(kubectl --namespace=usecase-v3 get service/usecase-v3-app-service  --output=go-template='{{(index .spec.ports 0).nodePort}}')

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
Secrets should be kept secret as the word implies. 
But now everyone who has permission to view [db-secret.yml](helm/templates/db/config/secret.yml) in our repository can decode the base64 database password and misuse it.
The current status can easily be used in a development environment. 
But talking about going to production with it can cause concerns.
One useful technology for capsuling security is [Hashicorp Vault](https://www.vaultproject.io/)
In [use case 4](https://github.com/Haagy/from-zero-to-k8s/tree/usecase/v4) we will make our helm deployment more dynamic and add the possibility to switch between for example dev and prod mode.


## Playing around
From here on you can adjust some configuration files and deploy the resource files again with:
```bash
helm upgrade --install --create-namespace --namespace usecase-v3 usecase-v3 usecase-v3/helm/
```
Find some best practices [here](https://helm.sh/docs/chart_best_practices/conventions/).
Or check out the default helm demo which can be created with:
```bash
helm create buildachart
# Creating my-demo
ls my-demo/
# Chart.yaml   charts/      templates/   values.yaml
```