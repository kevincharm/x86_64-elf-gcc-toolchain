IMAGE=kevincharm/x86_64-elf-gcc-toolchain
TAG=latest

build:
	docker build . -t $(IMAGE):$(TAG)

push:
	docker push $(IMAGE):$(TAG)
