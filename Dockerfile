# ==========================
# Stage 1: Build con Gradle
# ==========================
FROM gradle:8.7-jdk21 AS build
WORKDIR /app

COPY . .
RUN gradle clean build -x test

# ==========================
# Stage 2: Run con Java 21
# ==========================
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
