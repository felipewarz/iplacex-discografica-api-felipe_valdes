# ==========================
# Stage 1: Build con Gradle
# ==========================
FROM gradle:8.7-jdk21 AS build
WORKDIR /app

COPY . .
RUN gradle clean build -x test

# ==========================
# Stage 2: Run con OpenJDK
# ==========================
FROM openjdk:21-jdk-slim
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
