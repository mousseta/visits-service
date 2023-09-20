FROM ubuntu
RUN apt-get update -y
RUN apt-get install wget -y
RUN apt-get -qqy install openjdk-17-jdk openjdk-17-jre
#copie du jar dans l'image docker
ENV DOCKERIZE_VERSION v0.7.0 
RUN apt-get update \
    && apt-get install -y wget \
    && wget -O dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && apt-get autoremove -yqq --purge wget && rm -rf /var/lib/apt/lists/*
RUN tar xzf dockerize.tar.gz
RUN chmod +x dockerize
COPY target/spring-petclinic-visits-service-3.0.2.jar app.jar
entrypoint ["./dockerize","-wait=tcp://discovery-server:8761","-timeout=60s","--","java","-jar", "app.jar"]
