# docker-compose-server
Die IT-Infrastruktur des Makerspace Gütersloh.
Ein Ansible-basiertes Setup, das diverse Dienste mit Docker Compose startet. 
Weitere Infos im Wiki: [IT-Infrastruktur Über­sicht](https://wiki.makerspace-gt.de/de/IT-Infrastruktur/%C3%9Cbersicht).

# Nutzung

Ein Devcontainer mit den benötigten Tools ist bereitgestellt.

## OpenTofu

Mit OpenTofu werden die VM(s) aufgesetzt:
```
tofu plan
tofu apply

In _tofu/variables.tf_
```

IP der neuen VM -> intentory-Datei oder DNS-Eintrag anpassen.

## Ansible

Mit den drei Ansible-playbooks wird die VM (angegeben mit `-e "cluster=<staging/production/monitoring>"`):
- _setup-machine.yaml_:
  - Installiert und Initialisiert RKE2, Kubernetes- & Flux-CLI
  - kubeconfig-Setup
  - Download der _kubeconfig_-Datei, benannt je nach cluster
- _bootstrap-flux.yaml_: Initialisiert Flux für GitOps

# Flux setup bei Org mit Flux-user mit eigenem Personal access token:
> Siehe https://fluxcd.io/flux/installation/bootstrap/github/
> 
> GitHub Organization
> 
> If you want to bootstrap Flux for a repository owned by an GitHub organization, it is recommended to create a dedicated user for Flux under your organization.
> 
> Generate a GitHub PAT for the Flux user that can create repositories by checking all permissions under repo.
> 
> If you want to use an existing repository, the Flux user must have admin permissions for that repository.
