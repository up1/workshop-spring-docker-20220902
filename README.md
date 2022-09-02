# workshop-spring-docker-20220902



## 1. Build with Apache Maven
```
$git clone https://github.com/up1/workshop-spring-docker-20220902.git
$cd workshop-spring-docker-20220902
$./mvnw -B package
```

## 2. Build with maven + docker

Dockerfile
```
FROM openjdk:17.0.2-jdk-slim-buster
WORKDIR /app
COPY . .
RUN ./mvnw package
```

Step to run
```
$docker image build -t spring:1.0 .
```
