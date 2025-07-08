# Inception Project Makefile

# Variables
COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE = docker compose -f $(COMPOSE_FILE)

.PHONY: all up build down clean fclean re

# Default target
all: build up

# Build all images
build:
	$(COMPOSE) build

# Start all services
up:
	$(COMPOSE) up -d

# Stop all services
down:
	$(COMPOSE) down

# Clean containers and images (keep volumes)
clean: down
	$(COMPOSE) down --rmi local

# Full clean (including volumes)
fclean: down
	$(COMPOSE) down -v --rmi all
	docker system prune -af --volumes

# Rebuild everything from scratch
re: fclean all

# Show logs
logs:
	$(COMPOSE) logs -f

# Show status
status:
	$(COMPOSE) ps