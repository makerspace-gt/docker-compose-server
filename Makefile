start:
		docker-compose --project-directory traefik up -d --force-recreate
		docker-compose --project-directory keycloak up -d --force-recreate

stop:
		docker-compose --project-directory keycloak down --remove-orphans
		docker-compose --project-directory traefik down --remove-orphans

restart: stop start

deployment:
		ansible-playbook -i hosts deployment.yml 