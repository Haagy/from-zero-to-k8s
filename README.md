# Basics 1 (Container-images)
Starting from zero lets say you want to deploy a simple python rest api as a containerized application.

You can do so by just pulling an existing image from docker hub:
```bash
docker pull docker.io/haagy/python-rest-api:1.0
```

To start and test the app you can use the following commands:
```bash
docker run \
  --detach \
  --rm \
  --publish 5000:5000 \
  --name python-rest-api \
  docker.io/haagy/python-rest-api:1.0

# test rest api
curl localhost:5000
```
It should return `Hello! Greetings from Python Rest Api`

Great. You just deployed your first running containerized application.

## Next steps
The next step would be to deploy this application to a kubernetes cluster. 
To try this out go to the [next step](https://github.com/Haagy/from-zero-to-k8s/tree/basics/v2)

## Playing around
This branch also contains [the whole source code](rest-api) for building this simple application.
You can grab that an start playing around if you not quiet familiar with containerizing

Maybe changing the return message called by `index()` in [main.py](rest-api/main.py)
Use the following commands to apply your changes and build your own app:
```bash
# clone repo
git clone \
  --single-branch \
  --branch usecase/v4 \
  https://github.com/Haagy/from-zero-to-k8s.git \
  basics-v1

# build own image
docker build \
  --file basics-v1/rest-api/Containerfile \
  --tag my-app:my-tag \
  basics-v1/rest-api/
```

To start and test your own application execute:
```bash
# start own image
docker run \
  --interactive \
  --tty \
  --publish 6000:5000 \
  --name my-changed-app \
  my-app:my-tag

# test it
curl localhost:6000
```

If you have an running private registry and want to push your own build image to reuse it:
```
export REGISTRY_HOST=<MY_REGISTRY>
docker tag my-app:my-tag $REGISTRY_HOST/my-app:my-tag
docker push $REGISTRY_HOST/my-app:my-tag
```
