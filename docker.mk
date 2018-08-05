DOCKERIMAGE := rakudo-star-webservice-sop

all: build-image

build-image:
	docker build -t $(DOCKERIMAGE) .

test:
	docker run --rm \
		-v `pwd`:/work \
		$(DOCKERIMAGE) make test

exec:
	docker run --rm \
		-v `pwd`:/work \
		-it \
		$(DOCKERIMAGE) bash

clean:
	docker rmi $(DOCKERIMAGE)

.PHONY: all build-image test exec clean
