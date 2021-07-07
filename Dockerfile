# build go binaries here
FROM golang:1.16 as builder
 
WORKDIR /go/src
RUN git clone https://github.com/pulumi/kube2pulumi.git \
    && git clone https://github.com/pulumi/crd2pulumi.git \
    && cd crd2pulumi \
    && go mod tidy \
    && go build -o $GOPATH/bin/crd2pulumi -ldflags="-X github.com/pulumi/crd2pulumi/pkg/version.Version=1.0.0" main.go \
    && cd ../kube2pulumi \
    && go mod tidy \
    && go build -o $GOPATH/bin/kube2pulumi -ldflags="-X github.com/pulumi/kube2pulumi/pkg/version.Version=1.0.0" cmd/kube2pulumi/main.go


FROM alpine
WORKDIR /pulumi/offline
COPY --from=builder /go/bin/crd2pulumi /pulumi/offline/crd2pulumi
COPY --from=builder /go/bin/kube2pulumi /pulumi/offline/kube2pulumi
RUN apk add --no-cache tar 
COPY pulumi-resource-kubernetes-v3.4.1-linux-amd64.tar.gz pulumi-resource-kubernetes-v3.4.1-linux-amd64.tar.gz
RUN tar -xzf pulumi-resource-kubernetes-v3.4.1-linux-amd64.tar.gz
