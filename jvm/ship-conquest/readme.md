# Server Application Architecture
> Spring boot backend application written in kotlin with a postgresql database.

**RESTful API** for managing a ship exploring game backend application, featuring server-sent events (SSE) to enable real-time communication between the client and server.

## Setup
> This application is currently hosted and running at *url* via the GCP Platform

### In Your Local Machine
> To run the application on a local machine it is required to have installed the *Java SDK*, *PostgreSQL* and *Ngrok*.

For the database you need to have PostgreSQL running locally.

The following *SCONQUEST_CLIENT_ID* and *POSTGRES_URI* enviroment variables need to be added:
```shell
POSTGRES_URI=jdbc:postgresql://localhost:5432/postgres?user=<username>&password=<password>
SCONQUEST_CLIENT_ID=<Google client id>
```
To request access to the *Google client id* contact us.


To compile a *.jar* artifact of the application, run on a terminal:
```shell
cd <project directory>/jvm/ship-conquest
gradlew clean build
```

To run the compiled *.jar* aritfact
```shell
cd <project directory>/jvm/ship-conquest/build/libs
java -jar ./ship-conquest-0.0.1-SNAPSHOT.jar
```


## Architecture Design

![backend architecture](https://github.com/tomascarvalho7/ship_conquest/blob/main/jvm/ship-conquest/server_architecture.png)