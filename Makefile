DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

all:
	mkdir -p /home/chpasqui/data/mariadb
	mkdir -p /home/chpasqui/data/wordpress
	docker compose -f $(DOCKER_COMPOSE_FILE) up --build -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v
	sudo rm -rf /home/chpasqui/data/mariadb
	sudo rm -rf /home/chpasqui/data/wordpress

fclean :clean
	docker system prune -af

re : fclean all

.PHONY: all down clean fclean re
	