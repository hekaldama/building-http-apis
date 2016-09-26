IMAGE=hekaldama/building-http-apis:latest
COMMAND?=
SUDO?=

run:
	$(SUDO) docker run -v $$(pwd):/src -it --rm -p \
		9292:9292 $(IMAGE) $(COMMAND)

build:
	$(SUDO) docker build -t $(IMAGE) .

pull:
	$(SUDO) docker pull $(IMAGE)
