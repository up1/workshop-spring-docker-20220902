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

## 3. Build with maven + docker + multistage build

Dockerfile
```
FROM openjdk:17.0.2-jdk-slim-buster as step1
WORKDIR /app
COPY . .
RUN ./mvnw package

FROM openjdk:17.0.2-jdk-slim-buster
WORKDIR /app
COPY --from=step1 /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
```

Step to run
```
$docker image build -t spring:1.0 .
$docker container run spring:1.0
```

## Step 4 :: Copy only files and folders are used in the building process

Dockerfile
```
FROM openjdk:17.0.2-jdk-slim-buster as step1
WORKDIR /app
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src
RUN ./mvnw package
```

## Step 5 :: Cached from Docker Buildkit

Dockerfile
```
FROM openjdk:17.0.2-jdk-slim-buster as step1
WORKDIR /app
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src
RUN --mount=type=cache,target=/root/.m2,rw ./mvnw package
```

Step to run
```
$DOCKER_BUILDKIT=1 docker image build -t spring:1.0 . --progress=plain --no-cache

$DOCKER_BUILDKIT=1 docker image build -t spring:1.0 . --progress=plain
```

## Step 6 :: Working with Layers JAR

pom.xml
```
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <layers>
                    <enabled>true</enabled>
                </layers>
            </configuration>
        </plugin>
    </plugins>
</build>
```

Build with maven
```
$./mvnw package
```

List of layers jar from jar file
```
$java -Djarmode=layertools -jar target/demo-spring-0.0.1-SNAPSHOT.jar list
```

Extract layers jar
```
$java -Djarmode=layertools -jar target/demo-spring-0.0.1-SNAPSHOT.jar extract
```

Create Dockerfile_02
```
FROM openjdk:17.0.2-jdk-slim-buster as step1
WORKDIR /app
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src
RUN --mount=type=cache,target=/root/.m2,rw ./mvnw package

FROM openjdk:17.0.2-jdk-slim-buster as step2
WORKDIR /app
COPY --from=step1 /app/target/*.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

FROM openjdk:17.0.2-jdk-slim-buster
WORKDIR /app
COPY --from=step2 /app/dependencies/ .
COPY --from=step2 /app/snapshot-dependencies/ .
COPY --from=step2 /app/application/ .
COPY --from=step2 /app/spring-boot-loader/ .
CMD ["java", "org.springframework.boot.loader.JarLauncher"]
```

Run
```
$docker image build -t spring:2.0 -f Dockerfile_02 .
$docker container run spring:2.0
```

## Step 7 :: Working with Docker compose
```
$docker-compose build app_1
$docker-compose build app_2
$docker-compose build

$docker-compose up -d
$docker-compose ps
```

