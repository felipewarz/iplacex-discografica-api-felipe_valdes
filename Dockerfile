# ==========================
# Stage 1: Build con Gradle
# ==========================
FROM gradle:8.7-jdk21 AS build
WORKDIR /app

# Copiar todo el proyecto
COPY . .

# Construir el jar sin daemon (necesario en Render)
RUN gradle clean build -x test --no-daemon

# ==========================
# Stage 2: Run con Java 21
# ==========================
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copiar el jar generado desde el stage build
COPY --from=build /app/build/libs/*.jar app.jar

# Puerto estándar Spring
EXPOSE 8080

# Ejecutar la aplicación
ENTRYPOINT ["java","-jar","app.jar"]
