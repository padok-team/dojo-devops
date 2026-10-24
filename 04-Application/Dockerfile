FROM public.ecr.aws/docker/library/golang:1.27@sha256:f20d83a83e18dbd2a4714b8ffd4b30b287b6243962dd75608e86abcc63ba4efc AS builder
WORKDIR /app

COPY go.* .
RUN go mod download

COPY main.go .
ARG VERSION
RUN CGO_ENABLED=0 go build -ldflags="-s -w -X main.version=${VERSION}" -o=k8s-hello

FROM scratch AS runner
COPY --from=builder /app/k8s-hello /k8s-hello
ENTRYPOINT ["/k8s-hello"]
CMD []

