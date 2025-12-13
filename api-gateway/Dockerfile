FROM maven:3.9.6-eclipse-temurin-8 AS builder
COPY src /api-gateway/src
COPY pom.xml /api-gateway
RUN mvn -f /api-gateway/pom.xml clean package -DskipTests

ENV LOGIC_API_URL http://localhost:5000
ENV FEEDBACK_API_URL http://localhost:5001

FROM eclipse-temurin:8-jre
WORKDIR /app
COPY --from=builder /api-gateway/target/gateway-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar", "--glo4008.logic.api.url=${LOGIC_API_URL}", "--glo4008.feedback.api.url=${FEEDBACK_API_URL}"]