# Hackathon Container applicatifs CA Titres

## Lancer l'application

https://monapp09.hackathon-container.com/containerbank/

## Statut Intégration continue

[![Build Status](https://travis-ci.org/catitres/containerbank.svg?branch=master)](https://travis-ci.org/catitres/containerbank)

## Les instructions de build

Dans le fichier [BUILD.MD](BUILD.MD)

## Notre démarche

Démarche itérative en avançant pas à pas afin d'avoir toujours quelque chose qui marche.


## Nos étapes

### 1/Mise en place du setup

Repo source sur github au sein de l’organisation CA Titres
https://github.com/catitres/containerbank

Ajout intégration continue avec Travis ci:
https://travis-ci.org/catitres/containerbank

### 2/ Passage en docker de l’application d’origine
Essai de passer en docker avec le minimum d’impact au niveau du code de l’application.
Utilisation d’une image docker tomcat:8-jre8 qui permet de builder une image avec un tomcat et un war obtenue après compilation.
Utilisation du profil H2 pour avoir une application autonome dans un premier temps.

=> OK

### 3/ Optimisation de l’image docker
Utilisation d’une image tomcat:8-jre8-alpine plus légère

=> OK

Essai de passer à une application de type war exécutable avec serveur web embarqué pour passer sur une image docker ne contenant que le jre:
Utilisation du plugin maven tomcat7-maven-plugin.

=> KO : plugin obsolète, génère des erreurs.

=> On reste sur l’image docker tomcat

### 4/ Externaliser la configuration de l’application
Variabiliser l’application pour donner les références de la base de données à l’app en passant par les variables d’environnement lors du lancement de l’image avec docker.

Modifier le pom.xml pour que maven ne résolve plus les variables avec le profil
Test en local par ajout de variable d'environnement dans JAVA_OPTS pour passer les variables à l’app java :

=> OK : grâce à Spring résolution de variable.

Application à une image docker de l’app avec un H2 embarqué mais avec la configuration en variable d’environnement docker.

=> OK

App avec un mysql externe:
Configuration du mysql local au PC avec les scripts d’init
Run en local de l’app et du mysql

=> ok

Modif le code source pour supprimer le jdbc init car pas nécessaire avec le mysql.

Run en docker de l’app avec var env sur ip localhost /port/login/password du mysql local au pc

=> KO : car localhost est le localhost du container où il n’y a pas le mysql… :-)

Relance avec l’ip locale du PC

=> KO car mysql n’accepte pas par défaut les connexions autres que depuis localhost

=> modif du fichier de conf mysql pour binder sur l’ip du poste
=> OK

### 5/ Mise en place de la base de données
Utilisation d’une image docker mysql avec volume dédiée pour persister les données entre des arrêt/relance.
Pas à faire en production mais utile dans notre cas pour externaliser la base de données et ne pas avoir à déployer un mysql en local à la main.

### 6/ Passage en déploiement kubernetes
En parallèle:
- Utilisation de notre image de l’app avec H2 pour s’abstraire de la partie persistance de données dans un premier temps.
   => OK
- Etude des Persistent Volume Clain de Kubernetes pour la base de données mysql : le but étant de la passer en paramètre du service de l'app


## Architecture
![Image of Architecture](Architecture.png)


## Reste à faire

### Modifications au niveau de l'application :

Eclater la façade BankService pour faire 4 services :
- CustomerService
- AdvisorService
- CardService
- PaymentService

Ceci afin de mettre en api rest les services.

Mettre en place un cache distribué type redis

### Supervision/Monitoring :
Pour les logs, utiliser une solution ELK afin de centraliser les logs pour consultation/recherche.

### Performances :
Sur chaque micro service mettre un agent Zipkin pour pousser les infos de performances des requêtes sur un service Zipkin central

### Kubernetes :
Utilier les secrets pour mettre le mot de passe de la BDD au lieu de la variable d'environnement.
