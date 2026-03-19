This project has been created as part of the 42 curriculum by <chpasqui>

#Description (must presents the project, including its goal and a brief overview)

#Instructions (must contain any releavant information about compilation, installation, and/or execution)

#Resources (must lsit class references related to the topic as doc, articles, tutorials... as well as a decription of how AI was used for which taks ans which part of the project)
- concept : README of : https://github.com/Forstman1/inception-42
- concept : https://medium.com/@imyzf/inception-3979046d90a0
- tuto d'installation docker : https://github.com/vbachele/Inception
- super tuto : https://tuto.grademe.fr/inception/
- documentation : https://docs.docker.com/engine/storage/volumes/
- tuto pour mariaDB : https://medium.com/@ssterdev/inception-42-project-part-ii-19a06962cf3b
- AI : for the formating of the text, in the markdown documentations.
- super FLOWCHARTS : https://github.com/azedineouhadou/inception-42/tree/main

Difference between Virtual Machines vs Docker
VM : occupy a lot of memory space, take long time to boot u, has low efficiencz and voums storagge cannot be shared acrross the VM. Whereis docker, occupy less memory space, is quick to boot up because it uses the running kernel that uou using, high efficiency and volumes storage can be shared across the host and the containers.

INFRASTRUCTURE (computer) -> HOST OPERATING SYSTEM (OS : mac ou linux) -> DOCKER (engine installed in the host machine to run container) -> CONTAINER (app that is running in isolation from other apps) can be multiple of them.
Secrets vs Environment Variables
Docker Network vs Host Network
Docker Volumes vs Bind Mounts

DOCKER ENGINE : core component of Docker, lightweight runtime and packagin tool that bundles the app and its depencdencies into a single package (called container) and includes :
- Docker daemon : a backgorund process that manages Docker containers
- Docker client : a command-line tool that allow to interact with the Docker daemon (un terminal quoi non ?)

DOCKER IMAGE : is a lighweight, stand-alone executable package that includes everything needed to run a piece of software (app code, libraries, dependencies, runtime)

HOW DOES "DOCKER ENGINE" WORK :
1. write a Dockerfile which is contains the instructions to build a Docker image. 
2. use the Docker client to build the Docker image (command : docker build + path to the Dockerfile)
    -> the Docker daemon reads the Dockerfile and builds the image
3. use the Docker client to run the image as a container (command : docker run)
    -> The Docker daemon creates a container from the image and runs the app inside the container
4. The Docker engine provised a secure and isolated envrionemnt for the application to run in, and it manages resources such as CPU, memory, and storage for the container.
5. Use the Docker client to view, stop, and manage the containers running on you system. Or to oush the Docker image to a registry (like Docker Hub) in order to share with others.

DOCKERFILE : is a plain text (specfic format and synthax) file contains the instruction to build a single Docker Image
    - specify the base image to use (je pense genre Debian ou Alpine)
    - the dependencies and software to install
    - all other configurations / scripts to set up the environment for the app to run
    - Commands : to define the instructions for building the image
        - `FROM` : specifies the base image to use a the starting point for building the Docker image (provides fondational layers (est ce que ce sera un service ?) then possible to add additional lazers on top to customize the image)
        - `RUN` : executes a command in the terminal of the container. Ex: to install software or libraries that are needed by the app
        - `CMD` :specifies the main command that the container should run when it is started

DOCKER-COMPOSE FILE : is YAML file use to define and run multiple Docker containers as a single application
    - allows to define the services that make up your application (ex: tu veux utiliser wordpress et autre chose), and allows to start and stop all of the containers (app) with a single command.
    - Commands : to define the containers and how they should be set up and run
        - `services` : defines the services that make up the app. A service is a container that runs a specific app or component of your app.
        - `volumes` : defines the persistant storage for you app. A volume is a piece of storage that is attached to the container that is used to store data that should persist even when the container is stopped or removed (okay mais du coup il va ou ?). There are 2 types :
        1. Bind mount : file/directory on the host machine that is mounted into a container. Any changes made to it, are refleceted on the host machine and in any other containers that has be mounted with the same file/directory
        2. Named volume : is created and managed by Docker, stored in a specific location on the host machine, and is not tied to a specific file/directory on the host. Useful for storing data that needs to be shared between containers, can be easily attached and detached.
        - `networks` : defines the networks that containers should be connected to. A network is used to connect containers and allow them to communicate with each other.Existing types :
        1. Bridge : default network type when you install Docker. Allows containers to communicate with each other and the host machine, with no access to the outside world.
        2. Host : uses the host machine's network stcack and provides no isolation betwenn the host and the container
        3. Overlay > allows containers running on different Docker hosts to communicaiton with each other
        4. Macvlan: allows a container to have its own IP address on the same subnet as the hostmachine

SERVICES to be created :
- Mariadb : free and open-source database management system which is used to replace MySQL
- Nginx : is a webserver which stores hmtl, js, images files and use http request to display a website. Nginx conf documents will be used to config our server and the right proxy connexion.

QUESTIONS :
-questions pour mariadb : pourquoi faire mysql_install_db puis /etc/init.d/mysql start, pourquoi dans ce dossier alors que mysql nexiste pas dans ce dossier il y a juste 
mariadb, je peux pas lancer mariadb plutot ?
- quel est la difference entre DOCKER ENGINE et DOCKER IMAGE ?
- dans quel ordre est il mieux de proceder decrire dabord le docker-compose ou les Dockerfile de chaque service ?
- en fait une fois que je fais mes fichiers de docker, ca veut dire que dans ma vm, il va falloir que jinstalle les differents services cest ca ? je comprend pas exactement l'ordre dans lequel il faut proceder ? Commencer par jsute lancer Nginx cest ca ? mais donc il faut que j'installe docker cest ca ?
- Dans un article on parle de PID 1 et la difference avec Daemon Process, je n'ai pas compris. Du coup je dois faire quelque chose avec ce PID1 ?
- Jai egalement vu passer WP-CLI, cest un client wordpress cest ca ? un peu comme un docker client ? il est dit que cest un tool, mais ca veut dire quil se trouve ou dans ma structure de dossier, dasn tools de requirements ?
- Si j'aimerais faire les bonus, il est conseille de les implementer directement des le debut ou je peux les implementer apres avoir faire la partie obligatoire ?
- pour MariaDB, je ne comprend pas pourquoi je dois aller dasn 50-server.cnf pour faire ces changements, dans le sens que dans le sujet cela me dit que je dois creer un container pour mariaDB qui est donc la base de donnee pour Wordpress, et connecte au port 3306. En regardant des tutos je vois pleins de changements de config que je dois faire, cependant comment est-ce que j'aurais pu savoir faire ces changements et ou les faire. Surtout je ne les comprends pas, les tutos disent les changements a faire mais ne les explique pas. Typiquement sur ce site : https://medium.com/@ssterdev/inception-42-project-part-ii-19a06962cf3b
