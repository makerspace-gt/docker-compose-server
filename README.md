

> # TODO

- Template-ID festlegen
- User für Flux erstellen und dem Repo hinzugefügen, siehe docs von `flux bootstrap github`
- Secrets anpassen mit neuem age-key-pair in Vaultwarden
- Anpassen - Renovate-secrets & Repo-URL - und werden separate PRs für die Cluster erstellt? Muss es in allen Clustern laufen (no?)? 
- Monitoring see https://www.reddit.com/r/selfhosted/comments/1d1xu6z/is_there_some_good_uptime_monitor_tool_that_can/
  - Uptimekuma oder Gatus?
- Todo Dienste:
  - OpenCloud -> [OpenCloud in Kubernetes Basissetup](https://loku.be/250411-opencloud-on-kubernetes-locally-part-1) und [OpenCloud Docker Compose](https://docs.opencloud.eu/docs/admin/getting-started/container/docker-compose/)
  - Crowdsec -> [Crowdsec Bouncer Traefik plugin](https://plugins.traefik.io/plugins/6335346ca4caa9ddeffda116/crowdsec-bouncer-traefik-plugin)
  - Vaultwarden -> [Vaultwarden-Helm-Chart](https://github.com/guerzon/vaultwarden/blob/main/charts/vaultwarden/README.md)
  - Vikunja -> [Truecharts Vikunja-Helm-Chart](https://truecharts.org/charts/stable/vikunja/) und 
  - Zammad -> [Zammad-Helm-Chart](https://github.com/zammad/zammad-helm/blob/main/zammad/README.md)

> # TODO WENN VERSCHOBEN IN ORG REPO



# docker-compose-server

Die IT-Infrastruktur des Makerspace Gütersloh.
Ein Ansible-basiertes Setup, das diverse Dienste mit Docker Compose startet. 
Weitere Infos im Wiki: [IT-Infrastruktur Über­sicht](https://wiki.makerspace-gt.de/de/IT-Infrastruktur/%C3%9Cbersicht).

# Workflow

Der Devcontainer mit den benötigten Tools ist bereitgestellt und sollte genutzt werden.
Mit OpenTofu (in _./tofu/_) werden die drei Flux-cluster _staging_, _production_ und _uptime_ beim OpenNebula-Provider aufgesetzt.
Mit Ansible werden die Maschinen konfiguriert (Installation vom Kubernetes-Provider (Rancher RKE2)) und Aufsetzen von Flux.

## Secret management
Ansible nutzt `ansible-vault`, OpenTofu und Kubernetes `sops` mit einem `age`-Key.
Zum Neu-Verschlüsseln mit sops: `sops --encrypt --in-place <Datei>` - dabei muss ggf. _encrypted-regex_ in _./.sops.yaml_ angepasst werden - dort sind die zu verschlüsselnden Werte angegeben (z.B. "password", "username", ...).
Die _./.sops.yaml_ enthält auch den public age-Key.
Der private age-Key muss im lokalen Home-Verzeichnis vorhanden sein, siehe der mount in _devcontainer.json_, oder als Umgebungsvariable.

Wie `ansible-vault edit <file>` kann auch sops `sops edit <file>`, um eine Datei in einem Schritt zu
- entschlüsseln
- im definierten Editor zum bearbeiten öffnen
- beim Speichern und Schließen des Editors wieder verschlüsseln

## Provisioning mit OpenTofu

Wie bei Terraform sind die Schritte `tofu plan/apply/destroy/state list`.
Limitiert wird mit `-target=opennebula_virtual_machine.<environment>_vm`, z.B. `-target=opennebula_virtual_machine.uptime_vm`.

- Bei Erst-Installation/Update: `tofu init`
- Planung: `tofu plan -target=opennebula_virtual_machine.<environment>_vm` 
- Apply: `tofu apply -target=opennebula_virtual_machine.<environment>_vm`
- Zerstören: `tofu destroy -target=opennebula_virtual_machine.<environment>_vm`
- Zustand: `tofu state list`

### Variablen/Werte
_variables.tf_ enthält die Template-ID im OpenNebula-Interface, die für alle Maschinen genutzt wird, sowie die GitHub-Usernames, deren SSH-Keys automatisch den Maschinen hinzugefügt werden.
_tfsecrets.yaml_ enthält die OpenNebula-Interface-Zugangsdaten.
_cloud-init.yaml_ enthält dabei nützliche Standard-Werte und die Logik für die SSH-Keys.

## Aufsetzen mit Ansible

In _./ansible/_:
- Setup der Maschine: `ansible-playbook playbooks/setup-machine.yaml --limit staging -e "cluster=staging"`
  - Dabei wird auf einen Host limitiert, der entsprechende Flux-cluster muss auch definiert werden
  - Das Playbook installiert RKE2 und weitere CLIs und downloaded eine angepasste kubeconfig, benannt nach cluster, z.B. _./kubeconfigs/kubeconfig-staging_
- Flux bootstrappen: `ansible-playbook playbooks/bootstrap-flux.yaml --limit staging -e "cluster=staging"`

## Kubernetes-Struktur

Die in _./kubernetes/_ definierte Ordner-Struktur folgt der [von Flux empfohlenen Struktur](https://fluxcd.io/flux/guides/repository-structure/).
Das bedeutet:
- _cluster_: Cluster-Definitionen - 'welche Apps/Dienste verwenden uptime, staging, production?'
- _apps_: Benutzer-orientierte Applikationen wie WikiJS, Vikunja
- _infrastructure_: Interne Dienste wie Longhorn (Storage) und Traefik (Reverse Proxy)
- _monitoring_: Telemetrie und Uptime (Prometheus, Grafana, Uptimekuma, ...)

