FROM alpine
RUN apk add --no-cache tar
COPY pulumi-resource-kubernetes-v3.4.1-linux-amd64.tar.gz /offline/plugins/pulumi-resource-kubernetes-v3.4.1-linux-amd64.tar.gz
RUN tar -xzf /offline/plugins/pulumi-resource-kubernetes-v3.4.1-linux-amd64.tar.gz 
