# active_directory.
Préparation

Pour installer Windows Server c’est par ici :
➔ Image VMWare
➔ Image VirtualBox
➔ OVF

Mot de passe : “Laplateforme.io”

Job 0

Avant de vous lancer dans l’installation et la configuration de ce protocole
“complexe”, préparez un document pour présenter Active Directory, son
environnement, son fonctionnement et ses fonctionnalités, ses avantages et
inconvénients. Trouvez aussi quelques cas pratiques de son utilisation en
milieu professionnel...



Job 1

Vous êtes à l’essai comme adjoint au RSSI dans l’association “Pour les vieux“,
beau début !

On vous teste sur votre maîtrise de la gestion des accès et des privilèges sous
Windows. Avant de vous lancer sur le SI opérationnel de l’association, on vous
fait travailler sur un SI de test qui tourne sur des VMs.

Le DG vous demande de créer un annuaire basé sur un système
d’autorisations sélectif en fonction des métiers, des types de comptes et des
différentes opérations.
L’association comporte 4 établissements, 2 dans le 06 (siège et gabres) , un
dans le 83(hermitage) et un dans le 94 (cascade)

L'activité est structurée comme suit :
pour chaque établissement , les groupes suivants :
Administratif .
Cadres ( Direction , Médecin , Responsable technique , maîtresse de maison ,
responsable animation , psychologues).
Compta / aide-compta.
Animation.
Médical.
Technique .
Chaque groupe doit comporter le code du département ( par exemple Cadres06 ,
Cadres83 ... ).
Chaque Établissement doit avoir sa propre «OU» , avec des OU pour les Utilisateurs ,
Groupes et Ordinateurs .
Tous les utilisateurs auront «Azerty06!» comme mot de passe .
A changer lors de la 1ere connexion .



Personnel des Établissements :
● Gabres (06): 1 directeur , 1 adj direction , 2 médecins , 2 cadres de santé , 2
psychologues , 2 comptables , 12 Infirmières (IDE) , 48 Aide soignants (AS), 20 Agents
Service Hospitalier (ASH) , 1 secrétaire médicale , 1 secrétaire accueil , 1 secrétaire
animation , 1 informaticien ( administrateur du domaine ) .

● Hermitage (83): 1 directeur , 1 médecin , 1 psychologues ,1 comptable , 1 cadre
de santé , 6 Infirmières , 20 Aide soignants , 12 Agents Service Hospitalier , 1 secrétaire
accueil , 1 secrétaire animation .

● Cascade (94): 1 directeur , 1 médecin , 1 psychologues ,1 comptable , 1 cadre de
santé , 3 Infirmières , 15 Aide soignants , 6 Agents Service Hospitalier, 1 secrétaire
accueil , 1 secrétaire animation .
● Siege (06):
Cadres (1 Directeur Général , 1 DRH , 1 Resp tech , 1 qualiticien ,1 chef comptable)
Dossiers partagés pour chaque Établissement ( sauf siège ):
Médical : Infirmiers, médecin ,secrétaire médical accès complet et Aides
soignant (lecture seule ) .
Administratif : tous le monde contrôle total.
Animation : tous le monde lecture seule , Cadres et Animation contrôle total.
Technique : tous aucun accès , Cadres ,Technique et Informaticien contrôle
total .
Compta : tous aucun accès , Comptables et direction accès complet .
Cadres : Cadres accès complet , les autres aucun accès .
Bibles : tous lecture seule , Direction et Qualiticien accès complet .

Pour le Siège :
Administratif : tous contrôle total
Compta : compta et direction accès Total , le reste non autorisé et tous les



dossiers compta des établissements en accès total .
le responsable technique , tous les dossiers technique des établissements en
accès total .
Le DG et le DRH accès Total aux dossiers des établissements sauf dossier
médical .
Le qualiticien : tous les dossiers des établissements en lecture seule , sauf
dossiers Administratifs et bibles qui sont en accès Total .

Montage des lecteur réseau :
U: Dossier personnel des utilisateurs
M: Dossier Médical
S: Administratif /Animation
P: Compta
Z: Bibles
T: Technique
X: Cadres

À l’aide d’une matrice, d’un diagramme (UML, par exemple) ou d’un autre
outil, traduisez les permissions de groupes et placez-les dans les groupes
adaptés à leur niveau de droits.
Bravo ! Vous avez fait du PAM (Privilege Access Management).
Job 2

Après cette étape de conception, passons aux choses concrètes.

Commencez par installer Windows Server et activez AD sur une VM (d’autres



services et configurations sont à mettre en place).
Ajoutez à présent les utilisateurs suivants, veillez à ce que les droits et des
rôles que vous avez définis au préalable soient pris en compte.

Utilisateurs : une partie de la liste des utilisateurs et sur
https://github.com/thierry-rami/ADS-v2/raw/main/Utilisateur_ads.csv

Les droits peuvent être représentés par des accès en lecture et écriture sur
des dossiers et des fichiers qui représentent les accès de chaque catégorie.

Job 3

Maintenant que vous avez vos utilisateurs et un serveur AD opérationnel, il
faut créer des postes de travail. Configurez une ou plusieurs autres VM avec
une installation Windows Classique. Connectez ensuite ces postes à votre
environnement Active Directory.

Un employé de chaque catégorie devra pouvoir se connecter depuis son
poste client (VM), les droits d’accès propre à sa catégorie devront être
respectés.

Pour aller plus loin

Créer les scripts suivants :

- Récupération des comptes inactifs
- Identifications des doublons
- Alerte quand il y a des connexions après certaines heures
- Alerte lorsque plus de 3 modifications sont faites dans une



journée sur un fichier
Proposer quelques idées qui permettent de sécuriser le système.
