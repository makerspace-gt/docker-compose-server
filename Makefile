start:
		docker-compose --project-directory traefik up -d --force-recreate

stop:
		docker-compose --project-directory traefik down --remove-orphans

restart: stop start
