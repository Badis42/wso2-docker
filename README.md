# WSO2 Docker Images and clustered setups

If you are in the need of creating a full fledged WSO2 cluster in docker, this is the ideal start for you. You can simply deploy a WSO2 ESB/AS worker manager clustered setup with database mounts and deployment synchronization in docker, within just a matter of few seconds using a single script.

Most of the development is based on [WSO2 Private-PaaS](https://github.com/wso2/product-private-paas) repository and you can get the latest configurator distribution (ppaas-configurator-4.1.0-SNAPSHOT.zip) from there.

The artifacts contain several WSO2 docker images and template configuration files along with bash scripts to accomplish following.

* Clustering with wka membership scheme
* Separate MySQL-server container and svn-server container
* Shared user-store and registry MySQL database mounts
* SVN based artifact synchronization 

## Clustered setup

![Image](https://cloud.githubusercontent.com/assets/3282157/8763139/1362474a-2dad-11e5-942c-1ca9227a29c6.png)


## How to create a ESB/AS docker cluster?

* **Build required docker image**
  * Build base-image
  * Next, build ESB/AS docker images (To build the WSO2 AS, ESB docker images, you should  first build the base docker image)
  * Pull MySQL-server and svn-server docker images from docker hub
    I have used [sameersbn/mysql](https://registry.hub.docker.com/u/sameersbn/mysql/) mysql-server docker image and [krisdavison/svn-server](https://registry.hub.docker.com/u/krisdavison/svn-server/) svn-server docker image, without re-inventing the wheel

* **Execute run.sh bash script inside required server**


## Repository directory structure

```
   ├── docker
   │   ├── base-image
   │   │   ├── build.sh
   │   │   └── Dockerfile
   │   ├── wso2as-5.2.1
   │   │   ├── build.sh
   │   │   ├── Dockerfile
   │   │   └── run.sh
   │   ├── wso2esb-4.8.1
   │   │   ├── build.sh
   │   │   ├── Dockerfile
   │   │   └── run.sh
   │   │ 
   └── template-modules
       ├── wso2as-5.2.1
       │   
       └── wso2esb-4.8.1
          
```
## Steps to get started
##### (Below steps explains how to create a ESB cluster. Similar steps can be followed for AS as well)

If your host machine does not have docker installed, please follow the [docker documenation](https://docs.docker.com/installation/ubuntulinux/) in-order to get started. 

* Copy following files to the packages folder of base-image (wso2-docker/docker/base-image):
```
jdk-7u60-linux-x64.tar
ppaas-configurator-4.1.0-SNAPSHOT.zip
```

* Run build.sh file to build the docker image:
```
sh build.sh
```

* Navigate to wso2esb docker image directory (wso2-docker/docker/wso2esb-4.8.1) and copy the ESB distribution:
```
wso2esb-4.8.1.zip
```

* Run build.sh file with 'clean' param to build the docker image with template module:
```
sh build.sh clean
```

* List docker images and see if **lasinducharith/base-image** and  **lasinducharith/esb** images are avaiable:
```
docker images
```

* Pull MySQL server and SVN-Server docker images (optional) - Even if you do not pull the images here, when we execute the run script, it will download the images from docker-hub

```
docker pull sameersbn/mysql:latest
docker pull krisdavison/svn-server:v2.0
```

* Navigate to wso2esb docker image directory (wso2-docker/docker/wso2esb-4.8.1) and execute run script.
```
sudo ./run.sh
```

* If the cluster is created, you will see an output similar to below
```
MySQL server started: [name] mysql-db-server [ip] 172.17.1.17 [container-id] 37ee1775dcae50eb765981a5785c196070ca2a853b622ffd23a36d5f931bb418
Dep Sync SVN server started: [name] dep-sync-svn [ip] 172.17.1.18 [container-id] 14f287adff2beb84672a9017ff2dff2c2f383cf54ae1fabff1c28c96ec348b27
ESB wka member started: [name] wso2esb-1-wka [ip] 172.17.1.19 [container-id] fca889413dbce0fb9ddbd453b077aa7f9be2a8e7934ac707677dd096f23deb20
ESB member started: [name] wso2esb-2 [ip] 172.17.1.20 [container-id] f42dab2d10dfac45d2343fe7b1e0874f3acf8f5d9b5466f7808d3c1ad4c21184
ESB member started: [name] wso2esb-3 [ip] 172.17.1.21 [container-id] 65a81d5ed987e3640dc57d547af05e9a3fed14f7d6a5fbe0173fe9bbe84aa1e8
```

* Execute following docker command to see the details of running containers
```
docker ps
```

* You can ssh to ESB containers using following command. The default password will be 'wso2'.
```
ssh root@172.17.1.19
```

* To stop and delete the containers, you can run stop.sh and delete.sh scripts.


## How to apply patches/libs etc. to the server

* Navigate to wso2-docker/template-modules/wso2esb-4.8.1/files. You can copy what ever the required files there, before building the docker image.

## Next steps

* Handle failover
* Support Multiple WKA members
* Front product clusters by NGINX container
* Add support for other WSO2 products (APIM, IS, GREG, CEP etc.)


