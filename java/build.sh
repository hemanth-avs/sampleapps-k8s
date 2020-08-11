rm -rf jdk8u265

export tag=v4
FILE=bellsoft-jdk8u265+1-linux-amd64.tar.gz
if [ -f "$FILE" ]; then
    echo "$FILE exists."
    tar xf bellsoft-jdk8u265+1-linux-amd64.tar.gz
    docker build -f Dockerfile-uib -t java:$tag .
    docker run java:$tag /bin/bash -c "java -version"
else 
    echo "$FILE does not exist. Please copy file from Tanzu network"
fi
