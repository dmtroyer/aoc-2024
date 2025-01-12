FROM eclipse-temurin:21

# Install Scala
RUN apt-get update && apt-get install -y curl && \
    curl -fLo scala.tgz https://github.com/scala/scala3/releases/download/3.3.4/scala3-3.3.4.tar.gz && \
    tar xzf scala.tgz && \
    mv scala3-3.3.4 /usr/local/scala && \
    ln -s /usr/local/scala/bin/scala /usr/bin/scala && \
    ln -s /usr/local/scala/bin/scalac /usr/bin/scalac && \
    ln -s /usr/local/scala/bin/scaladoc /usr/bin/scaladoc && \
    rm scala.tgz

# Set Scala home
ENV SCALA_HOME /usr/local/scala
ENV PATH $PATH:/usr/local/scala/bin

CMD ["scala"]
