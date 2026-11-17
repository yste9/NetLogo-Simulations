# De paisibles moutons - v0

Modèle des pages 34–36 : naissance, reproduction, mortalité et consommation d'une ressource renouvelable, sans prédateur.

## Lancer et régler

Ouvrir `paisibles_moutons_v0.nlogo` dans NetLogo, cliquer INITIALISE puis GO. Cliquer GO à nouveau pour suspendre. Les curseurs sont globaux ; les champs `sante` et `age` sont individuels ; `herbe` appartient à chaque patch.

| Réglage | Défaut repris de la p. 35 | Plage choisie |
|---|---:|---:|
| nb-moutons-init | 75 | 0–200 |
| seuil-herbe-deplacement | 25 | 0–100 |
| conso-herbe | 8 | 1–20 |
| croissance-herbe | 1 | 0–10 |
| proba-reproduction | 0,001 | 0–1 |
| proba-mort-naturelle | 0,0001 | 0–1 |

Les probabilités sont des proportions **par tour**, pas des pourcentages : 0,001 correspond à 0,1 %. L'effectif sert au prochain INITIALISE ; les autres paramètres servent aux prochains tours.

## Dynamique

INITIALISE crée des moutons blancs à positions aléatoires, santé 100 et âge 0 ; chaque patch reçoit entre 50 et 100 unités d'herbe. Le monde torique contient 51 × 51 patches ; cette taille est un choix de réalisation. La forme vectorielle de mouton est incluse dans le fichier.

Un tour sépare déplacement, alimentation, vie des moutons, croissance de l'herbe, tick et tracé. Un mouton change de pâturage en avançant d'une unité dans une direction aléatoire si l'herbe locale est sous le seuil. Il consomme `conso-herbe` si la quantité disponible suffit, gagne 1 de santé (maximum 100), sinon perd `conso-herbe` de santé. L'ordre aléatoire d'`ask` départage des agents concurrents sur une même ressource.

La santé nulle ou négative entraîne la mort. Un parent de santé au moins 50 peut avoir un petit selon la probabilité réglée ; le petit a santé 50, âge 0 et reste sur la case du parent, dont la santé devient `floor(sante * 0.75)`. Les nouveau-nés n'agissent pas dans la même phase de naissance. L'âge augmente à chaque phase de vie. Sous une santé de 10, `random 10 > sante` peut provoquer un décès par malnutrition ; la mortalité naturelle s'applique ensuite aux survivants.

Chaque patch gagne `croissance-herbe`, avec un plafond strict de 100. Le sol sans herbe est beige et le vert code la quantité présente. La courbe superpose l'effectif et **l'herbe moyenne par patch** : leurs unités diffèrent. Les ticks continuent même sans moutons pour observer la repousse.

## Conventions et écarts explicites par rapport à la capture p. 36

- La croissance est plafonnée par `min 100`, pour respecter le maximum annoncé p. 34, même avec une croissance décimale ou élevée.
- L'alimentation accepte l'égalité `herbe >= conso-herbe` ; la capture emploie `>`.
- La reproduction exige une santé d'au moins 50 pour traduire le besoin de nourriture annoncé p. 34 ; la capture illustre seulement le tirage probabiliste.
- La mort est immédiate à santé nulle. La mortalité naturelle concerne tous les survivants, y compris ceux de faible santé, alors que la capture la place dans la branche opposée à la malnutrition.
- Les orientations utilisent 360 degrés. La palette et les plages des sliders sont des choix de présentation.

Une croissance supérieure à la consommation peut favoriser l'abondance ; une pression élevée sur l'herbe peut provoquer une baisse de santé puis de population. Aucun équilibre ni cycle n'est garanti. Voir [les résultats réels](../../../documentation/validation-exercices.md).
