FROM openjdk:17.0.2-jdk-slim-buster as step1
WORKDIR /app
COPY . .
RUN ./mvnw package

FROM openjdk:17.0.2-jdk-slim-buster
WORKDIR /app
COPY --from=step1 /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]