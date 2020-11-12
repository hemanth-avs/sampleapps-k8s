export tag=v5

FILE=bellsoft-jdk11.0.9+12-linux-amd64.tar.gz

if [ -f "$FILE" ]; then
    echo "$FILE exists."
    docker build -f Dockerfile-uib -t java:$tag .
    docker run java:$tag /bin/bash -c "java -version"
    docker images java:$tag
else 
    echo "$FILE does not exist. Please copy file from Tanzu network"
fi
