FROM golang:1-bookworm

RUN go install -v github.com/go-delve/delve/cmd/dlv@latest

CMD ["tail", "-f", "/dev/null"]
