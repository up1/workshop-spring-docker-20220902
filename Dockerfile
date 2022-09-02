FROM openjdk:17.0.2-jdk-slim-buster
WORKDIR /app
COPY . .
RUN ./mvnw package