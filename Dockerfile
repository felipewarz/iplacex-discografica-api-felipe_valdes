# ==========================
# Stage 1: Build con Gradle Wrapper
# ==========================
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Copiamos todo el proyecto
COPY . .

# Permisos para ejecutar gradlew en Linux
RUN chmod +x ./gradlew

# Build usando el wrapper, sin daemon y con memoria controlada (Render Free)
RUN ./gradlew clean build -x test --no-daemon -Dorg.gradle.jvmargs="-Xmx1g -XX:MaxMetaspaceSize=256m"

# ==========================
# Stage 2: Run con Java 21
# ==========================
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
