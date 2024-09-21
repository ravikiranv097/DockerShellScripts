# Docker Shell Scripts to Stop Running Containers, Delete Stopped Containers and Delete Docker Images.

- Clone or download a local copy of the Repository to local dev environment and provide execute permissions.

```sh
git clone -b v1 git@github.com:LTTS-CTO-DevEx/docker-shell-scripts.git
cd docker-shell-scripts
sudo chmod a+x .
```
  
## Stop Running Containers

```sh
sudo ./doc-stop-all-containers.sh
```

## Delete Stopped Containers
  
```sh
sudo ./doc-del-stopped-containers.sh
```

## Docker System Prune to clear Cache
  
```sh
sudo docker system prune
```

## Delete Docker Images
  
```sh
sudo ./doc-del-images.sh
```
or
```sh
sudo ./doc-del-images-new.sh
```

## License
LTTS 
