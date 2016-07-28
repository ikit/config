# Configuration de base avec SaltStack  
([Merci Oodnadatta](https://github.com/Oodnadatta/salt-conf))


La configuration de SaltStack se trouve dans `/srv/salt`


## Pour installer a configuration Salt sur Ubuntu
1) Télécharger et installer le paquet.
```sh
sudo apt install salt-minion
```

2) Créer le répertoire pour salt.
```sh
sudo mkdir -p /srv
```

3) Récupérer tous les fichiers de github et les mettre dans `/srv/salt`.
```sh
sudo git clone https://github.com/ikit/config /srv/salt
```

4) Lancer salt et appliquer la configuration saltstack sur la machine.
```
sudo apt update #(met à jour la liste des paquets disponibles à l'installation)
sudo salt-call --local state.highstate
sudo apt ugrade #(met à jour tous les paquets sur le système pour qu'ils soient tous à la dernière version)
```

## Pour ajouter de nouveaux programmes à la configuration
Chaque fichier .sls dans `/srv/salt` contient des règles pour salt. Ils sont pris en compte uniquement s'ils sont listés dans le fichier `top.sls`.
Il peut également s'agir de fichiers `init.sls` dans un répertoire.

1) Ajouter le logiciel au fichier `nom_du_fichier.sls`

2) Lancer salt-call pour installer le nouveau programme
```
sudo salt-call --local state.sls nom_du_fichier
```


# Securisation du server

Pour les expliquations en détails : [c'est là]( https://openclassrooms.com/courses/securiser-son-serveur-linux)
Mais en gros à minima, il faut penser à faire :
* Maj de la politique du firewall (tout interdir sauf...)
* Changer le port par défaut pour se connecter via ssh
* Modifier le fichier conf ssh : /etc/ssh/sshd_config
  * changer le port (le même que dans iptables)
  * interdir les authent en root
  * interdir les authent sans mot de passe




# Installation des services avec docker
* Suivre la doc de docker en fonction de la distrib
* Créer un répertoire (root) /docker à la racine où seront déployé tout les containers
* 
