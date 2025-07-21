# Spring Boot Update 2

This is a simple Spring Boot application designed for demonstration and deployment purposes. It includes features like containerization with Docker and supports cloud deployment using tools like AWS EC2 and Amazon ECR.

## ✨ Features

- Spring Boot RESTful API
- Docker support
- Maven-based build system
- Easily deployable to cloud environments
- Health check via Spring Boot Actuator

## 🛠️ Tech Stack

- Java 17+
- Spring Boot
- Maven
- Docker

## 📦 Getting Started

### Prerequisites

- Java installed (preferably version 17+)
- Maven
- Docker (optional, for container-based deployment)

### Clone the Repository

```bash
git clone https://github.com/Adetola-Adedoyin/spring-boot-update-2.git
cd spring-boot-update-2

Run Locally

mvn clean package
java -jar target/*.jar

Run with Docker

# Build Docker image
docker build -t springboot-demo .

# Run the container
docker run -d -p 8080:8080 springboot-demo

Then open http://localhost:8080 in your browser.
Health Check

GET http://localhost:8080/actuator/health

Returns basic app health info.
🚀 Deployment

This app can be deployed to:

    AWS EC2 (using Docker or standalone JAR)

    AWS ECR (Docker image hosting)

    Jenkins or GitHub Actions (for CI/CD)

📁 Project Structure

spring-boot-update-2/
├── src/
├── target/
├── Dockerfile
├── pom.xml
└── README.md

🙋‍♂️ Author

Adetola Adedoyin
🔗 GitHub
