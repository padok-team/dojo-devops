FROM public.ecr.aws/docker/library/golang:1.23@sha256:8e529b64d382182bb84f201dea3c72118f6ae9bc01d27190ffc5a54acf0091d2 AS builder
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

