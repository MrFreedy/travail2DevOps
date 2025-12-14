# Description de la remise

### Nom complet: LENNE Arthur, EL OUAD Zakaria
### NIP: 537 389 563, 537 404 664

### Liste des codes et descriptions des fonctionnalités sélectionnées:

- (FA31) Intégration d’un outil de gestion de journaux (Loki) ==> 5%  
  Centralisation des logs de tous les pods Kubernetes via Loki, consultables depuis Grafana.

- (FA32) Intégration de monitoring des ressources physiques (CPU, Mémoire, etc.) avec Prometheus ==> 5%  
  Collecte et supervision des métriques du cluster Kubernetes (CPU, mémoire, état des pods, services).

- (FA34) Visualisation des métriques et journaux (Grafana) ==> 10%  
  Visualisation unifiée des métriques Prometheus et des logs Loki via Grafana.

**Total des fonctionnalités avancées implémentées : 20%**

---

### Directives nécessaires à la correction

- Le projet est déployé sur un cluster Kubernetes local (kind).
- Les services sont accessibles via Ingress.
- Grafana est exposé via port-forward ou Ingress selon la configuration locale.
- Les dashboards Grafana permettent :
  - la visualisation des métriques Prometheus
  - l’exploration des logs Loki
- Aucun outil externe n’est requis en dehors de Kubernetes, Helm et kubectl.


### Commentaires généraux

L’ensemble du projet a été validé fonctionnellement sur un environnement Kubernetes local (kind) exécuté sur macOS (architecture arm64).
Certaines adaptations techniques ont été nécessaires afin de contourner des limitations spécifiques à l’environnement et à des dépendances obsolètes, tout en respectant strictement les consignes du TP.

La validation du frontend a été effectuée via kubectl port-forward, ce qui a permis de confirmer le bon fonctionnement applicatif indépendamment du comportement de l’Ingress NGINX sur macOS.
En effet, des problèmes connus de redirection réseau entre Docker Desktop, kind et l’Ingress Controller sur macOS ont nécessité l’utilisation du port-forward pour les tests locaux. Cette approche n’impacte pas le déploiement final sur un environnement Linux standard, tel que celui utilisé pour la correction.

#### Adaptation technique – Images Java (arm64)

Les images Docker ```openjdk:8-jre-alpine``` et ```maven:3.5-jdk-8-alpine``` étant dépréciées et non compatibles avec l’architecture arm64, elles ont été remplacées par des images maintenues et multi-architecture :

- ```eclipse-temurin:8-jre```

- ```maven:3.9.6-eclipse-temurin-8```

Le projet reposant sur Spring Boot 1.5.x, Java 8 a volontairement été conservé afin de garantir la compatibilité applicative.
Cette adaptation est conforme aux directives communiquées par l’enseignant et a été documentée afin d’assurer la transparence de la démarche.

#### Observabilité et validation des services

L’observabilité du système a été renforcée via :

- Prometheus pour la collecte des métriques système et applicatives,

- Loki pour la centralisation des journaux des services,

- Grafana pour la visualisation unifiée des métriques et des logs.

L’ensemble des services expose des endpoints ```/health```, utilisés à la fois pour les probes Kubernetes et pour la supervision, garantissant une visibilité claire sur l’état global de l’application.

### Preuves de mise en œuvre des fonctionnalités avancées

Les fonctionnalités FA31, FA32 et FA34 ont été validées via l’interface Grafana.

Des captures d’écran sont fournies dans le dossier `submission/screenshots` :
- Visualisation des logs centralisés via Loki (FA31)
- Monitoring des ressources Kubernetes via Prometheus (FA32)
- Visualisation unifiée des métriques et logs dans Grafana (FA34)
