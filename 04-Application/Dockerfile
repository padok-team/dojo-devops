FROM public.ecr.aws/docker/library/golang:1.27@sha256:2920bb124f1a2e12a1d39f0cab756ae0068441ee1da7655dec7f5e374944095b AS builder
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

