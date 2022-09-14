FROM public.ecr.aws/docker/library/golang:alpine AS builder
WORKDIR /app
COPY main.go .
ARG VERSION
RUN go env -w GO111MODULE=off && CGO_ENABLED=0 go build -ldflags="-s -w -X main.version=${VERSION}" -o=k8s-hello

FROM scratch AS runner
COPY --from=builder /app/k8s-hello /k8s-hello
ENTRYPOINT ["/k8s-hello"]
CMD []

