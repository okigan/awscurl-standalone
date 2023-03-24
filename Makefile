PHONY:build
build:
	docker build -t awscurl-standalone .

PHONY:run
run: build
	docker run -it awscurl-standalone /usr/local/bin/awscurl --help

