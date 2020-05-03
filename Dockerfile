FROM maven:3.6.3-jdk-8 as builder

LABEL MAINTAINER="Emmanuel Oriarewo"
LABEL maintainer.email="hollaemor@gmail.com"


COPY ./pom.xml ./pom.xml

RUN mvn dependency:go-offline -B


# copy other source files
COPY ./src ./src

# package app. Skip tests
RUN mvn package -DskipTests


# run artifact using JRE
FROM openjdk:8u252-jre-slim

ENV GIT_URI="git_repo_here" PORT="8888"
EXPOSE $PORT


WORKDIR /app

COPY --from=builder target/config-server*.jar config-server.jar

ENTRYPOINT [ "java", "-jar", "config-server.jar" ]
