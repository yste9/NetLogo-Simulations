# Une vie de tortue - v2

**Consigne p. 30 :** modifier la couleur selon l'énergie et afficher le nombre de morts par case. Les six curseurs et le moniteur de v1 sont conservés ; la dynamique de déplacement reste celle de v1.

Valeurs par défaut : 30 tortues, nid (0,0), vitesse maximale 2, énergie maximale 20, coût 1. La réserve initiale est un entier entre 1 et `energie-max`, comme en v0/v1. `energie-init` mémorise cette réserve pour normaliser la couleur, sans effectuer de nouveau tirage.

`setup` initialise les patches et les agents. `go` fait agir les tortues puis incrémente le temps. La distance est tirée entre 0 et la vitesse maximale et le cap est indépendant à chaque déplacement. La mort intervient dès l'épuisement, avec enregistrement sur la case du dernier emplacement. Aucun ravitaillement ni obstacle n'est ajouté à cette version.

## Utilisation

Ouvrir le fichier `.nlogo` de cette version dans NetLogo officiel. Régler les curseurs, cliquer **INITIALISE**, puis **GO**. Un second clic sur GO suspend la simulation. Le moniteur indique `count turtles` et la vue affiche les ticks. Les curseurs ne sont pas écrasés par INITIALISE.

Un patch est une case fixe du monde, une tortue un agent mobile, et l'observateur pilote `setup` et `go`. Les sliders déclarent automatiquement leurs variables globales ; `turtles-own` et `patches-own` déclarent les états individuels des tortues et des cases. Le monde torique de 51 × 51 patches est conservé. La distance coûte `distance-parcourue * energie-par-case`. Un dernier pas est limité par la réserve disponible ; l'effectif ne peut pas augmenter, puisqu'il n'y a aucune reproduction.

Les réglages d'effectif, de nid et de réserve initiale servent au prochain INITIALISE. La vitesse et le coût servent au prochain tour. Suspendre avant les réglages et réinitialiser pour comparer des expériences. Une vitesse nulle ne dépense pas d'énergie ; zéro tortue initiale entraîne un arrêt sans tick. Une simulation avec ravitaillement ou blocage peut durer indéfiniment : ne pas interpréter l'absence d'extinction comme une panne.

## Couleurs et décès

`energie-init` est la réserve propre à chaque agent. La proportion `energie / energie-init` pilote une couleur RGB : vert `[0 210 0]` au plein, orange `[128 105 0]` à moitié, rouge près de zéro. La couleur est actualisée à l'initialisation et à chaque tour pour les survivantes. Une tortue morte disparaît : elle n'est pas affichée en rouge après son décès.

Chaque patch possède `morts`, initialisé à 0. La procédure `mourir` incrémente ce compteur sur `patch-here`, affiche sa valeur avec `plabel`, puis appelle `die`. Les cases sans décès restent sans étiquette pour préserver la lisibilité. Les comptes sont cumulatifs jusqu'au prochain INITIALISE. L'invariant à vérifier est : `count turtles + sum [morts] of patches = effectif créé au setup`.

La palette, le fond marron clair et le masquage des zéros sont des choix de réalisation ; la page 30 exige la variation de couleur et le nombre de morts par case, sans fixer cette présentation.

## Validation

Voir [les tests v2-v4](../../../documentation/validation-suite.md) pour les résultats réels, leur reproduction et les contrôles visuels restant à faire. Les règles et conventions sont également commentées en français dans le code NetLogo. La dynamique est exécutée exclusivement par NetLogo natif.
