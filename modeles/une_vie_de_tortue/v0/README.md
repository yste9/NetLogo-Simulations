# Une vie de tortue - v0

## Le cours et les choix retenus

La page 27 fixe les comportements et les cinq paramètres conceptuels. La page 28 contient une capture du code : les valeurs ci-dessous et le tirage initial d'énergie sont lisibles. Les pages 15-25 donnent la structure utilisée ici : déclarations, initialisation, dynamique et sous-procédures. Les pages 29-33 décrivent les versions suivantes, exclues de ce livrable.

| Paramètre | Variable | Valeur initiale | Origine |
|---|---|---|---|
| Effectif | `nb-tortues` | 30 | Capture p. 28 |
| Position du nid | `x-nid`, `y-nid` | (0, 0) | Capture p. 28 |
| Distance maximale par tour | `vitesse-max` | 2 | Capture p. 28 |
| Énergie initiale maximale | `energie-max` | 20 | Capture p. 28 |
| Coût par unité de distance | `energie-par-case` | 1 | Capture p. 28 |

Chaque tortue reçoit `1 + random energie-max`, soit un entier uniforme entre 1 et 20 inclus. Elles n'ont donc pas nécessairement la même énergie au départ. Le paramètre est une borne maximale, pas une réserve commune fixée à 20.

Trois ajustements explicites par rapport à la capture :

- La capture semble écrire `random (vitesse-max + 2)`, ce qui autorise 3 pour une vitesse maximale de 2. Ici, `random (vitesse-max + 1)` respecte la borne de la page 27.
- La capture teste `energie < 1` avant le déplacement, ce qui décale la mort au prochain tour. Ici, la mort intervient dès `energie <= 0`, y compris après le déplacement, conformément à la demande.
- Le dernier déplacement est limité par l'énergie encore disponible. Une tortue ayant 1 unité ne parcourt pas 2 unités avec un coût de 1. Ce choix évite une réserve négative et garantit le coût du trajet réellement effectué. Avec d'autres paramètres, ce dernier trajet peut être fractionnaire.

La topologie n'est pas précisée dans le texte de la page 27. Le choix de réalisation est un monde torique de 51 × 51 patches, coordonnées des centres de -25 à 25 : sortir à droite fait rentrer à gauche, de même verticalement. La distance consommée est la longueur du trajet, pas la différence brute entre les coordonnées avant et après un passage de bord. Les limites géométriques sont -25,5 et 25,5. Aucune collision ni énergie supplémentaire aux bords.

## Comprendre les agents

Une **tortue** est un agent mobile. Elle possède sa position réelle (`xcor`, `ycor`), son orientation (`heading`) et sa réserve `energie`. Plusieurs tortues peuvent partager une position ; à l'initialisation, elles se superposent toutes au nid. Leur superposition visuelle ne signifie pas qu'il n'existe qu'une tortue.

Un **patch** est une case fixe de la grille. Ses coordonnées `pxcor` et `pycor` sont entières. Il ne nourrit pas les tortues en v0. Le nid est une position commune de départ, sans agent supplémentaire ni fonction de ravitaillement.

L'**observateur** pilote le monde : il exécute les boutons et lance `ask turtles [...]`. Les instructions à l'intérieur d'`ask` sont exécutées par les tortues, dans un ordre aléatoire.

Les variables de `globals` décrivent les paramètres partagés. `turtles-own [ energie ]` crée au contraire une réserve distincte pour chaque tortue. Une variable globale d'énergie ferait partager la même réserve à tous les agents et empêcherait de représenter leurs durées de vie individuelles. Les variables `let`, comme `distance-tiree`, sont locales à une exécution de procédure.

## Initialiser et avancer

`setup` efface les agents et l'état précédent avec `clear-all`, appelle `initialise-globals`, puis `initialise-tortues`. `create-turtles` crée l'effectif demandé ; `setxy` place chaque agent au nid et le tirage initialise sa réserve. `reset-ticks` fixe le temps à zéro.

`go` s'arrête immédiatement si le monde est vide. Sinon, il demande à chaque tortue de se déplacer et de consommer son énergie, puis appelle `tick`. Un tick représente un tour pendant lequel toutes les tortues présentes ont pu agir, pas une seconde réelle. La vitesse d'affichage de l'application ne change pas ce sens.

La sous-procédure tire une distance entière parmi 0, 1 et 2. `random` exclut sa borne supérieure. Si la distance est positive, `random 360` tire un cap entier de 0 à 359 degrés. `forward` suit ce cap ; la distance se mesure en unités de largeur de patch, y compris en diagonale. Un tirage nul produit du repos gratuit. Aucune persistance du cap, reproduction ou tentative de retour au nid.

Le calcul est :

`distance-parcourue = min(distance-tiree, energie / energie-par-case)`

`energie-apres = max(0, energie-avant - distance-parcourue * energie-par-case)`

`die` supprime immédiatement l'agent si sa réserve est nulle ou négative à l'entrée, ou devient nulle après le déplacement. Une fois la dernière tortue supprimée, le dernier tour est compté ; l'appel suivant à GO s'arrête sans modifier les ticks.

Exemple **illustratif, pas une observation expérimentale** : réserve initiale 5, coût 1, vitesse maximale 2.

| Tour | Distance tirée | Distance parcourue | Coût | Énergie restante |
|---|---:|---:|---:|---:|
| 0 | - | - | - | 5 |
| 1 | 2 | 2 | 2 | 3 |
| 2 | 0 | 0 | 0 | 3 |
| 3 | 1 | 1 | 1 | 2 |
| 4 | 1 | 1 | 1 | 1 |
| 5 | 2 | 1 | 1 | 0 : mort |

## Utilisation et résultats attendus

Ouvrir `vie_de_tortue_v0.nlogo` dans NetLogo, cliquer INITIALISE puis GO. Cliquer GO pour suspendre. Ajuster la vitesse d'affichage si nécessaire pour observer les tours. Le compteur de ticks appartient à la vue ; aucun slider ou moniteur de v1 n'est ajouté.

Le nombre de tortues ne peut qu'être constant ou décroissant. L'énergie de chaque survivante ne peut qu'être constante ou décroissante. Avec les valeurs initiales, les décès dépendent de la réserve et des distances tirées. Toutes les tortues finissent par mourir avec probabilité 1 ; il n'existe pas de durée maximale déterministe, car une succession de tirages nuls est possible. Plusieurs exécutions peuvent donner des résultats différents.

Pour modifier les paramètres, éditer `initialise-globals`, puis relancer INITIALISE. Garder un effectif entier positif ou nul, une vitesse entière positive ou nulle, une énergie maximale entière strictement positive et un coût strictement positif. Le nid doit être dans le monde. Une vitesse nulle empêche l'épuisement des réserves positives. Les tests fournis concernent les valeurs livrées et les cas ciblés décrits dans `documentation/validation-v0.md`.

La validation automatique et ses limites sont détaillées dans [le rapport de validation](../../../documentation/validation-v0.md). Utiliser `observations.md` pour vos propres expériences.
