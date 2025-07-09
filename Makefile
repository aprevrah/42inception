COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE = docker compose -f $(COMPOSE_FILE)
DATA_DIR = $(HOME)/data

.PHONY: all up build down clean fclean re setup

all: setup build up

# Setup data directories
setup:
	@mkdir -p $(DATA_DIR)/mysql $(DATA_DIR)/wordpress
	@grep -q "127.0.0.1 aprevrha.42.fr" /etc/hosts || echo "127.0.0.1 aprevrha.42.fr" | sudo tee -a /etc/hosts

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