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
```

