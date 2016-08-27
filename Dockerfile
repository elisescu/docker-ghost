# Pull base image.
FROM ubuntu:12.04

RUN \
  apt-get update && \
  apt-get install -y unzip ca-certificates wget

# Install nvm
RUN \
  cd /tmp/ && \
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash && \
  mv ~/.nvm /nvm && \
  chmod -R 777 /nvm

ENV NODE_VERSION 0.10
ENV NVM_DIR /nvm

# Install Ghost
RUN \
  cd /tmp && \
  . /nvm/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION && \
  wget https://ghost.org/zip/ghost-latest.zip && \
  unzip ghost-latest.zip -d /ghost && \
  rm -f ghost-latest.zip && \
  cd /ghost && \
  npm install --production && \
  sed 's/127.0.0.1/0.0.0.0/' /ghost/config.example.js > /ghost/config.js && \
  useradd ghost --home /ghost && \
  echo $NODE_VERSION >> /etc/bashrc

# Add files.
ADD start.bash /ghost-start

# Set environment variables.
ENV NODE_ENV production

# Define mountable directories.
VOLUME ["/data", "/ghost-override"]

# Define working directory.
WORKDIR /ghost

# Define default command.
CMD ["bash", "/ghost-start"]
