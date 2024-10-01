IMAGE_NAME := amsa-labs
PORT := 3000
CONTAINER_NAME := amsa-labs-container

.PHONY: build run stop clean all

build:
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME) .

run:
	@echo "Running Docker container..."
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):$(PORT) $(IMAGE_NAME)

stop:
	@echo "Stopping Docker container..."
	docker stop $(CONTAINER_NAME)

clean:
	@echo "Removing Docker container..."
	docker rm $(CONTAINER_NAME)

all: build run