FROM golang:alpine

# Install minimum necessary dependencies,
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3 protoc protobuf ca-certificates
RUN apk add --no-cache $PACKAGES

# Set environment variables
ENV GOPATH="/go"
RUN export PATH="$PATH:$(go env GOPATH)/bin"

# Get protobuf
RUN go get github.com/golang/protobuf/protoc-gen-go
RUN go get github.com/regen-network/cosmos-proto/protoc-gen-gocosmos

# Set working directory for the build
WORKDIR /go/src/github.com/cosmos/cosmos-sdk

# Add source files
COPY . .

# Build Cosmos SDK
RUN make build-simd

EXPOSE 26658 26657

# Run simd by default, omit entrypoint to ease using container with simcli
CMD ["nsd", "start"]
