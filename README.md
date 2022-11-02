# From zero to kubernetes
Starting from zero lets say you want to deploy a simple python rest api
this branch consists of [source code](rest-api) for building a simple containerized python rest application.

### Use the following commands to build the app:
```
cd rest-api
docker build --file Containerfile --tag python-rest-api:1.0
```

### To start and test the app you can use the following commands:
```
docker run --interactive --tty --publish 5000:5000 --name python-rest-api python-rest-api:1.0
curl localhost:5000
```

### If you want to push this image to a self-hosted image registry use:
```
export REGISTRY_HOST=<YOUR_HOST>
docker tag python-rest-api:1.0 $REGISTRY_HOST/python-rest-api:1.0
docker push $REGISTRY_HOST/python-rest-api:1.
```

### If you are able to use docker hub you can do by:
```
docker pull docker.io/library/haagy/python-rest-api:1.0
```