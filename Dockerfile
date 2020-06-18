# stage 1 : Create customize JVM
FROM azul/zulu-openjdk-alpine:11.0.4 AS default

RUN jlink \
  --verbose \
  --add-modules \
  java.base,java.sql,java.naming,java.desktop,java.management,jdk.management,java.security.jgss,java.instrument,java.logging,java.xml,jdk.unsupported  \
  --compress 2 \
  --strip-debug \
  --no-header-files \
  --no-man-pages \
  --output /opt/jvm_small

 # Stage 2 : maven build for back
FROM maven:3.6.1-jdk-11 AS backbuild
WORKDIR /opt/workspace

COPY pom.xml .
RUN mvn -B install -N

COPY back/pom.xml back/
RUN mvn -B dependency:resolve-plugins dependency:go-offline sonar:help

COPY back/ back/
RUN cd back && mvn clean install && jar -xf target/back-0.0.1-SNAPSHOT.jar

# Stage 3 : Create back module using Customize JVM
FROM alpine:3.10.1 as back

COPY --from=default /opt/jvm_small /opt/jvm_small

WORKDIR /opt/compliance

COPY --from=backbuild /opt/workspace/back/BOOT-INF/lib lib/
COPY --from=backbuild /opt/workspace/back/BOOT-INF/classes app/

COPY back/start.sh .

ENV JAVA_HOME=/opt/jvm_small
ENV PATH="$PATH:$JAVA_HOME/bin"

CMD ["/bin/sh", "/opt/compliance/start.sh"]
