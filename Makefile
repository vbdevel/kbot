VERSION="v.1.0.0"
test:
	echo "test"
	echo "next"
format:
	gofmt -s -w ./
build:
	go build -v -o kbot -ldflags "-X="github.com/vbdevel/kbot/cmd.appversion=${VERSION}