PWD=$(shell pwd)
UID=$(shell id -u)

DEPLOY_FOLDER=deploy
VERSION=$(shell cat VERSION)
USER=$(shell whoami)

# Docker variables
TAR_IMAGE=rsna_tar_$(VERSION)_$(USER).tar
IMAGE_NAME=rsna_image_$(VERSION)_$(USER)
CONTAINER_NAME=rsna_container_$(VERSION)_$(USER)

# number of CPUs to use
N_CPUS = $(shell perl -wln -e "/^N_CPUS = \K.*/ and print $$&;"  rsna.conf)
# memory usage limit
MEMORY_LIMIT = $(shell perl -wln -e "/^MEMORY_LIMIT = \K.*/ and print $$&;" rsna.conf)
# port to use for notebooks
PORT = $(shell perl -wln -e "/^PORT = \K.*/ and print $$&;" rsna.conf)

help:
	@echo "This script is used to run the kaggle rsna competition container creation and other submodules."
	@echo ""
	@echo "Arguments:"
	@echo ""
	@echo "	Docker commands:"
	@echo "		- build			Build the Docker image (if connection available)"
	@echo "		- save			Save a Docker image to a tar file (to send to client)"
	@echo "		- load			Load a Docker image from a tar file"
	@echo "		- notebook              Launch a Jupyter Notebook on the port specified in rsna.conf"




build:
	docker build --cache-from $(IMAGE_NAME) -t $(IMAGE_NAME) .

save: build
	docker save --output $(TAR_IMAGE) $(IMAGE_NAME)

load:
	docker load -i $(TAR_IMAGE)

notebook:
	docker run --rm -it -e ID=$(UID) -v $(PWD)/notebooks/:/app/notebooks/ -p $(PORT):$(PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME) jupyter notebook --NotebookApp.token='' --NotebookApp.password='' --ip 0.0.0.0 --port $(PORT) --no-browser --allow-root --notebook-dir /app/notebooks/

bash:
	docker run --rm -it -e ID=$(UID) -v $(PWD)/notebooks/:/app/notebooks/ -p $(PORT):$(PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME) bash

