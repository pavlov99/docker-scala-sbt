FROM ubuntu:14.04
MAINTAINER Kirill Pavlov <kirill.pavlov@phystech.edu>

# Add sbt repo to sources list
RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list

# Add a repo where OpenJDK can be found.
RUN apt-get install -y software-properties-common wget
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update

# Auto-accept the Oracle JDK license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

RUN apt-get install -y oracle-java8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install Scala
ENV SCALA_VERSION 2.11.7
ENV SCALA_DEB http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb

RUN wget --quiet --output-document=scala.deb SCALA_DEB
RUN dpkg -i scala.deb
RUN rm -f *.deb

# Install Scala Build Tool sbt
apt-get install -y sbt

# print versions
RUN java -version
# scala -version returns code 1 instead of 0 thus || echo '' > /dev/null
RUN scala -version || echo '' > /dev/null
# fetches all sbt jars from Maven repo so that your sbt will be ready to be used when you launch the image
RUN sbt --version

# To run bash command, use docker run -it <image> /bin/bash
