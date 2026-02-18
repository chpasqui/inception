This project has been created as part of the 42 curriculum by <chpasqui>

#Description (must presents the project, including its goal and a brief overview)

#Instructions (must contain any releavant information about compilation, installation, and/or execution)

#Resources (must lsit class references related to the topic as doc, articles, tutorials... as well as a decription of how AI was used for which taks ans which part of the project)
- README of : https://github.com/Forstman1/inception-42
- AI : for the formating of the text, in the markdown documentations.

Difference between Virtual Machines vs Docker
VM : occupy a lot of memory space, take long time to boot u, has low efficiencz and voums storagge cannot be shared acrross the VM. Whereis docker, occupy less memory space, is quick to boot up because it uses the running kernel that uou using, high efficiency and volumes storage can be shared across the host and the containers.

INFRASTRUCTURE (computer) -> HOST OPERATING SYSTEM (OS : mac ou linux) -> DOCKER (engine installed in the host machine to run container) -> CONTAINER (app that is running in isolation from other apps) can be multiple of them.
Secrets vs Environment Variables
Docker Network vs Host Network
Docker Volumes vs Bind Mounts

DOCKER ENGINE : core component of Docker, lightweight runtime and packagin tool that bundles the app and its depencdencies into a single package (called container) and includes :
- Docker daemon : a backgorund process that manages Docker containers
- Docker client : a command-line tool that allow to interact with the Docker daemon (un terminal quoi non ?)

DOCKER IMAGE : is a lighweiht, stand-alone executable package that includes everything needed to run a piece of software (app code, libraries, dependencies, runtime)

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
        - `CMD` :specifies the main command that teh container should run when it is started

DOCKER-COMPOSE FILE : is YAML file use to define and run multiple Docker containers as a single application
    - allows to define the services that make up your application (ex: tu veux utiliser wordpress et autre chose), and allows to start and stop all of the containers (app) with a single command.
    - Commands : to define the containers and how they should be set up and run
        - `services` : defines the services that make up the app. A service is a container that runs a specific app or component of your app.
        - `volumes` : defines the persistant storage for you app. A volume is a piece of storagge that is attached to the container that is used to store data that should persist even when the container is stopped or removed (okay mais du coup il va ou ?). There are 2 types :
        1. Bind mount : file/directory on the host machine that is mounted into a container. Any changes made to it, are refleceted on the host machine and in any other containers that has be mounted with the same file/directory
        2. Named volume : is created and managed by Docker, stored in a specific location on the host machine, and is not tied to a specific file/directory on the host. Useful for storing data that needs to be shared between containers, can be easily attached and detached.
        - `networks` : defines the networks that containers should be connected to. A network is used to connect containers and allow them to communicate with each other.


