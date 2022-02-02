# Post-installation de Postfix

Entrer votre adresse mail et votre mot de passe dans le fichier /etc/postfix/sasl_passwd

``` 

nano /etc/postfix/sasl_passwd

[smpt.gmail.com]:587 votreadresse@domaine.fr:motdepasse

``` 

Entrer votre addresse mail dans le fichier /etc/icinga/objects/contacts_icinga.cfg

``` 

nano /etc/icinga/objects/contacts_icinga.cfg

define contact...

email 			votreadresse@domaine.fr

``` 
Lancer la commande suivante pour prendre en compte la modification:

```

/usr/sbin/postmap /etc/postfix/sasl_passwd

```

Activer l'**Accès moins sécurisé des applications** depuis son compte google

Désactiver un service puis vérifier ses mails (attendre 5 minutes entre chaque test)

```

tail -f /var/log/icinga/icinga.log pour vérifier l'envoi de l'email

```
