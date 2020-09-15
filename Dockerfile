# FROM golang:1.15.2
#
# RUN apt-get update && apt-get install -y protobuf-compiler \
#                      curl make git libc-dev bash gcc \
#                      python3 ca-certificates &&  apt-get clean
#
# # Set environment variables
# ENV GOPATH="/go"
# RUN export PATH="$PATH:$(go env GOPATH)/bin"
#
# # Get protobuf
# RUN go get github.com/golang/protobuf/protoc-gen-go
# RUN go get github.com/regen-network/cosmos-proto/protoc-gen-gocosmos
#
# # Set working directory for the build
# WORKDIR /go/src/github.com/cosmos/cosmos-sdk
#
# # Add source files
# COPY . .
#
# # Build the node
# RUN make proto-gen
# RUN make build-simd
#
# EXPOSE 26656 26657 1317 9090
#
# CMD ["nsd", "start"]

FROM golang:alpine

# Install minimum necessary dependencies,
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3 protoc protobuf ca-certificates
RUN apk add --no-cache $PACKAGES

# Set environment variables
ENV GOPATH="/go"
RUN export PATH="$PATH:$(go env GOPATH)/bin"

# Get protobuf
# RUN go get github.com/protocolbuffers/protobuf
RUN go get github.com/golang/protobuf/protoc-gen-go
RUN go get github.com/regen-network/cosmos-proto/protoc-gen-gocosmos

# Set working directory for the build
WORKDIR /go/src/github.com/cosmos/cosmos-sdk

# Add source files
COPY . .

# build Cosmos SDK, remove packages
# RUN make proto-gen
RUN make build-simd

EXPOSE 26656 26657 1317 9090

# Run simd by default, omit entrypoint to ease using container with simcli
CMD ["nsd", "start"]
