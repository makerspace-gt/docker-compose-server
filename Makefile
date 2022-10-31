start:
		docker-compose --env-file .env --project-directory traefik up -d --force-recreate 

stop:
		docker-compose --env-file .env --project-directory traefik down --remove-orphans

restart: stop start
