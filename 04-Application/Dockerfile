FROM public.ecr.aws/docker/library/golang:1.20@sha256:8f9af7094d0cb27cc783c697ac5ba25efdc4da35f8526db21f7aebb0b0b4f18a AS builder
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

