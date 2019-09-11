FROM maven:3.6.0-jdk-11-slim

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./ /usr/src/app/

run mvn clean install

WORKDIR /usr/src/app/target

EXPOSE 8080

CMD ["java", "-jar", "projeto-backend.jar"]