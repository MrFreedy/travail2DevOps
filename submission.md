# Description de la remise

### Nom complet  
LENNE Arthur, EL OUAD Zakaria

### NIP  
537 389 563, 537 404 664

---

## Liste des codes et descriptions des fonctionnalités sélectionnées
- **(FA1) Sécurisation et chiffrement des communications via certificats TLS (Ingress HTTPS) - 10%**  
  Mise en place du chiffrement HTTPS au niveau de l’Ingress NGINX grâce à des certificats TLS, garantissant la sécurité des communications entre le navigateur et les services exposés.


- **(FA31) Intégration d’un outil de gestion de journaux (Loki) – 5%**  
  Centralisation des logs de l’ensemble des pods Kubernetes via Loki.  
  Les journaux applicatifs sont collectés automatiquement (Promtail) et consultables en temps réel depuis Grafana.

- **(FA32) Intégration du monitoring des ressources physiques (Prometheus) – 5%**  
  Supervision des ressources du cluster Kubernetes (CPU, mémoire, état des pods et des services) via Prometheus.

- **(FA34) Visualisation des métriques et journaux (Grafana) – 10%**  
  Visualisation unifiée des métriques Prometheus et des logs Loki via Grafana à l’aide de dashboards préconfigurés.

**Total des fonctionnalités avancées implémentées : 20%**

---

## Directives nécessaires à la correction

### Déploiement du projet

- Le projet est déployé sur un cluster Kubernetes local (kind).
- **Toutes les ressources Kubernetes nécessaires sont fournies dans le dossier `./submission`.**
- Le déploiement complet peut être réalisé via la commande unique suivante :

```bash
kubectl apply -f ./submission
```
Aucune configuration manuelle supplémentaire n’est requise après cette commande.

### Prérequis techniques

Les outils suivants sont requis sur la machine de correction :

- ```kubectl```

- ```helm``` (utilisé uniquement pour la génération des manifests Kubernetes)

> ⚠️ Important
Helm n’est pas requis au moment de la correction.
Il a été utilisé uniquement pour générer les manifests Kubernetes statiques (Prometheus, Grafana, Loki, Promtail) via la commande helm template.

### Accès aux services applicatifs

Les services applicatifs sont exposés via Ingress NGINX.

Sur macOS (Docker Desktop + kind), des limitations réseau connues peuvent empêcher un accès direct à l’Ingress.

Dans ce cas, la validation a été réalisée via ```kubectl port-forward```, par exemple :

```bash
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80
```


Cette méthode permet de valider le fonctionnement applicatif indépendamment des contraintes réseau locales.

### Accès à Grafana

Grafana est déployé dans le namespace ```monitoring```.

Accès recommandé pour la correction :

kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80


- URL : http://localhost:3000

- Identifiants :

  - Utilisateur : admin

  - Mot de passe : prom-operator

Les identifiants sont générés automatiquement et stockés dans les secrets Kubernetes.


## Dashboards Grafana

Un dashboard Grafana est automatiquement provisionné au démarrage.

Aucun import manuel n’est nécessaire.

Le dashboard permet :

- la consultation des logs applicatifs via Loki

- la visualisation de l’utilisation CPU par pod

- la visualisation de l’utilisation mémoire par pod


## Commentaires généraux

L’ensemble du projet a été validé fonctionnellement sur un environnement Kubernetes local (kind) exécuté sur macOS (architecture arm64).

Certaines adaptations techniques ont été nécessaires afin de contourner :
- des limitations liées à l’architecture arm64,
- des images Docker obsolètes,
- et des comportements réseau spécifiques à Docker Desktop sur macOS, tout en respectant strictement les consignes du TP.

### Validation via port-forward

La validation du frontend et des services backend a été réalisée via ```kubectl port-forward```.
Cette approche a permis de confirmer le bon fonctionnement applicatif indépendamment du comportement de l’Ingress NGINX sur macOS.

Ces limitations sont spécifiques à l’environnement local et n’impactent pas un déploiement Linux standard, tel que celui utilisé pour la correction.

### Adaptation technique – Images Java (arm64)

Les images Docker initiales :
- ```openjdk:8-jre-alpine```
- ```maven:3.5-jdk-8-alpine```

étant dépréciées et incompatibles avec l’architecture arm64, elles ont été remplacées par :

- ```eclipse-temurin:8-jre```
- ```maven:3.9.6-eclipse-temurin-8```

Le projet utilisant Spring Boot 1.5.x, Java 8 a été conservé afin de garantir la compatibilité applicative, conformément aux directives communiquées par l’enseignant.

### Observabilité et supervision

L’observabilité du système repose sur :

- Prometheus pour la collecte des métriques Kubernetes et système

- Loki pour la centralisation des journaux applicatifs

- Grafana pour la visualisation unifiée

Tous les services exposent un endpoint ```/health```, utilisé pour :
- les probes Kubernetes (liveness/readiness)
- la supervision globale de l’état de l’application

### Dashboards et logs préconfigurés

Les datasources Grafana (Prometheus et Loki) sont automatiquement provisionnées.

Le dashboard Grafana est chargé via ```ConfigMap``` au démarrage. Il est visible dans les dashboards de Grafana sous le nom de **Kubernetes Observability Microservices**

Les panels sont explicitement liés aux bonnes datasources afin d’éviter tout fallback automatique.

### Preuves de mise en œuvre des fonctionnalités avancées

Les fonctionnalités FA31, FA32 et FA34 ont été validées via l’interface Grafana.

Des captures d’écran sont disponibles dans le dossier ```submission/screenshots```


Elles illustrent :

- la centralisation des logs via Loki (FA31)

- le monitoring CPU et mémoire via Prometheus (FA32)

- la visualisation unifiée des métriques et logs dans Grafana (FA34)

#### Sécurisation des communications – HTTPS (FA1)

Les communications externes vers l’application sont sécurisées via HTTPS grâce à l’utilisation de certificats TLS configurés au niveau de l’Ingress NGINX.

Le chiffrement est appliqué à l’entrée du cluster Kubernetes, ce qui garantit que toutes les requêtes entre le navigateur et les services (frontend et API Gateway) sont transmises de manière sécurisée.  
Les services internes communiquent ensuite en HTTP au sein du cluster, conformément aux bonnes pratiques Kubernetes.

Le frontend React utilise des routes relatives (`/api/...`) pour les appels API, ce qui permet au navigateur de réutiliser automatiquement le protocole HTTPS sans configuration supplémentaire côté client.

Lors des phases de validation locale sur macOS, l’accès aux services a pu être réalisé via `kubectl port-forward` à des fins de test uniquement. Cette méthode n’affecte pas la configuration finale HTTPS mise en place via l’Ingress et les certificats TLS.

##### Accès HTTPS pour la validation

L’Ingress HTTPS peut être testé localement via :

kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8443:443

Puis accéder à l’application via :
https://localhost:8443

Un avertissement de certificat auto-signé peut apparaître selon la configuration locale, ce qui est attendu dans un environnement de test.


## Remarque finale

Les composants d’observabilité (Prometheus, Grafana, Loki, Promtail) ont été déployés initialement via Helm, puis exportés en manifests Kubernetes statiques (helm template) afin de respecter la contrainte suivante :

Un déploiement unique via kubectl apply -f ./submission, sans dépendance à Helm lors de la correction.


---