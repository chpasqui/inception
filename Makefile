DOCKER_COMPOSE_FILE = srcs/docker-compose.yml
LOGIN := $(shell whoami)
export LOGIN

all:
	mkdir -p /home/$(LOGIN)/data/mariadb
	mkdir -p /home/$(LOGIN)/data/wordpress
	docker compose -f $(DOCKER_COMPOSE_FILE) up --build -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v
	sudo rm -rf /home/$(LOGIN)/data/mariadb/*
	sudo rm -rf /home/$(LOGIN)/data/wordpress/*

fclean: clean
	docker system prune -af

re: fclean all

.PHONY: all down clean fclean re
