FROM openjdk:17.0.2-jdk-slim-buster as step1
WORKDIR /app
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src
RUN --mount=type=cache,target=/root/.m2,rw ./mvnw package
#RUN ./mvnw package

FROM openjdk:17.0.2-jdk-slim-buster
WORKDIR /app
COPY --from=step1 /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]