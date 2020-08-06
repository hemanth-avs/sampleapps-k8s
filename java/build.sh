rm -rf jre8u265

FILE=bellsoft-jre8u265+1-linux-amd64.tar.gz
if [ -f "$FILE" ]; then
    echo "$FILE exists."
    tar xf bellsoft-jre8u265+1-linux-amd64.tar.gz
    docker build -t java:latest .
    docker run  java:latest /bin/bash -c "java -version"
else 
    echo "$FILE does not exist. Please copy file from Tanzu network"
fi
