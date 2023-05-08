
APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=gcr.io
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGET_ARCH="amd64"	# arm64
debug:
	echo ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}
get:
	go get
lint:
	golint
format:
	gofmt -s -w ./
test:
	go test -v
build-arm: format get
	CGO_ENABLED=0 GOOS="linux" GOARCH="arm64" go build -v -o kbot -ldflags "-X="github.com/vbdevel/kbot/cmd.appversion=${VERSION}	
build-linux: format get
	CGO_ENABLED=0 GOOS="linux" GOARCH=${TARGET_ARCH} go build -v -o kbot -ldflags "-X="github.com/vbdevel/kbot/cmd.appversion=${VERSION}
build-windows: format get
	CGO_ENABLED=0 GOOS="windows" GOARCH=${TARGET_ARCH} go build -v -o kbot -ldflags "-X="github.com/vbdevel/kbot/cmd.appversion=${VERSION}
build-darwin: format get
	CGO_ENABLED=0 GOOS="darwin" GOARCH=${TARGET_ARCH} go build -v -o kbot -ldflags "-X="github.com/vbdevel/kbot/cmd.appversion=${VERSION}

image:
	docker build --build-arg OS="linux" . -t ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}	
arm:
	docker build --build-arg OS="arm" . -t ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}	
linux:
	docker build --build-arg OS="linux" . -t ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}	
windows:
	docker build --build-arg OS="windows" . -t ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}	
darwin:
	docker build --build-arg OS="darwin" . -t ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}			
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}
clean:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGET_ARCH}
	