# Une vie de tortue - v1

La page 29 du cours demande de rendre tous les paramètres modifiables dans l'interface et d'afficher le nombre de tortues à chaque tour. Cette version ajoute **six sliders et un moniteur**, en conservant la dynamique de v0. Les deux coordonnées du nid représentent un seul paramètre conceptuel, mais nécessitent deux réglages.

## Lancer

1. Ouvrir `vie_de_tortue_v1.nlogo` dans NetLogo officiel.
2. Régler les curseurs, puis cliquer **INITIALISE**.
3. Cliquer **GO** pour avancer en continu ; cliquer à nouveau pour suspendre.
4. Lire **Tortues vivantes** et le compteur de ticks de la vue.

Le fichier comprend toute l'interface. Dans VS Code, il peut être consulté et modifié ; la simulation s'exécute dans NetLogo. La v0 reste disponible dans son propre dossier.

## Réglages

| Curseur | Défaut | Plage | Pas | Application |
|---|---:|---:|---:|---|
| `nb-tortues` | 30 | 0 à 200 | 1 | Prochain INITIALISE |
| `x-nid` | 0 | -25 à 25 | 1 | Prochain INITIALISE |
| `y-nid` | 0 | -25 à 25 | 1 | Prochain INITIALISE |
| `vitesse-max` | 2 | 0 à 10 | 1 | Prochain tour |
| `energie-max` | 20 | 1 à 100 | 1 | Prochain INITIALISE |
| `energie-par-case` | 1 | 0,1 à 5 | 0,1 | Prochain tour |

Les valeurs par défaut proviennent de la capture p. 28. **Les plages des curseurs sont des choix de réalisation**, non des valeurs imposées par le professeur. Les coordonnées sont limitées aux centres des patches du monde existant. Le coût reste strictement positif pour éviter une division par zéro ; l'énergie maximale reste un entier positif pour le tirage initial.

Suspendre GO avant de modifier les réglages facilite l'interprétation. Pour une nouvelle expérience, régler tous les curseurs puis cliquer INITIALISE. Changer l'effectif, le nid ou l'énergie maximale ne modifie pas les agents déjà créés. Changer la vitesse ou le coût pendant une exécution affecte les prochains déplacements ; la réserve existante reste individuelle.

## Ce qui change dans le code

Un slider déclare automatiquement une variable globale portant son nom. Les six variables ne figurent donc plus dans un bloc `globals` explicite : les redéclarer produirait une erreur. `turtles-own [ energie ]` reste nécessaire pour les réserves individuelles.

`setup` exécute `clear-all`, qui conserve les valeurs des sliders, crée les tortues à partir de ces réglages puis remet les ticks à zéro. La procédure `initialise-globals` de v0 est retirée pour que le bouton ne remplace pas les choix de l'utilisateur par les valeurs fixes.

Le moniteur utilise directement le reporter `count turtles`. Il affiche le nombre d'agents vivants sans compteur redondant à maintenir. Les mises à jour d'affichage peuvent être regroupées si NetLogo tourne très vite ; ralentir pour observer chaque tour.

## Dynamique conservée

Toutes les tortues partent au nid avec une énergie entière entre 1 et `energie-max`. À chaque tour, une distance entière est tirée entre 0 et `vitesse-max`, puis un cap aléatoire lorsque la distance est positive. Le déplacement est limité par la réserve disponible et consomme `distance-parcourue * energie-par-case`. Une tortue à énergie nulle disparaît immédiatement. Le monde reste torique et les ticks cessent d'avancer lorsque le monde est vide.

Avec une vitesse nulle, les tortues à réserve positive restent vivantes et immobiles ; le temps continue de progresser. Avec zéro tortue initiale, GO s'arrête sans avancer le temps. Avec un coût décimal, les distances du dernier pas peuvent être fractionnaires.

Aucun changement de couleur en fonction de l'énergie, comptage des morts sur les patches, reproduction, retour au nid ou obstacle : ces extensions ne font pas partie de v1.

Voir [les explications pédagogiques de v0](../v0/README.md), [la validation de v1](../../../documentation/validation-v1.md) et [la grille d'observation](observations.md).
