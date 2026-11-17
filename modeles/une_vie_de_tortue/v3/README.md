# Une vie de tortue - v3

**Consignes p. 31-32 :** déplacement vers l'avant avec variation angulaire, retour au nid sous un seuil d'énergie, plein à l'arrivée. Les couleurs et compteurs de v2 sont conservés.

## Paramètres supplémentaires et valeurs du cours

| Curseur | Défaut | Plage | Signification |
|---|---:|---:|---|
| `angle-deplacement` | 100 | 0 à 180 degrés | Amplitude maximale de variation du cap en exploration |
| `energie-seuil-retour` | 30 | 0 à 100 % | Seuil relatif à la réserve individuelle initiale |

La capture p. 32 montre 20 tortues, énergie maximale 50, vitesse 2, coût 1, nid (0,0), angle 100 et seuil 30. Ces valeurs sont reprises pour v3. Les plages sont des choix de réalisation. Les paramètres hérités gardent les plages de v1.

La capture utilise `energie-init` et compare l'énergie à `0.01 * energie-seuil-retour * energie-init` : le seuil est donc un **pourcentage**, pas une quantité absolue. Elle tire aussi la réserve dans la moitié haute du maximum : `floor(energie-max / 2) + random floor(energie-max / 2)`. Pour 50, cela donne 25 à 49. Ici, chaque demi-réserve est au moins 1 afin de gérer également le réglage `energie-max = 1`. Pour les maxima impairs, cette formule peut rester deux unités sous le maximum : nous conservons la formule illustrée plutôt que d'affirmer une borne inclusive.

## Déroulement d'un tour

Si la réserve est déjà nulle à l'entrée, la tortue est enregistrée comme morte. Sinon, une énergie **strictement inférieure** au seuil active `retour?`. En exploration, la tortue tire une distance entière entre 0 et `vitesse-max` et une rotation entière entre `-angle-deplacement` et `+angle-deplacement`, bornes incluses. L'inclusion de la borne positive est notre interprétation explicite du « -n° à +n° » de la page 31.

Pendant le retour, l'agent vise le nid et demande la vitesse maximale, limitée par la distance restante et sa réserve. Il utilise la plus courte direction sur le monde torique. Le retour reste actif jusqu'au plein. Un déplacement arrivant exactement au nid avec zéro énergie permet le plein avant le test de mort ; sans arrivée, zéro signifie la mort immédiate. Cette priorité d'arrivée et le plafonnement du dernier pas sont des conventions explicites, la capture ne montrant pas la totalité du traitement.

Une tortue présente au nid en fin de tour retrouve `energie-init` et reprend l'exploration au tour suivant. Le plein n'est pas `energie-max` commun à tous : c'est la réserve individuelle de la capture p. 32. Le nid est noir et ses coordonnées sont mémorisées au setup pour qu'un curseur déplacé ne téléporte pas le nid pendant GO.

Exemple illustratif : réserve initiale 20, seuil 50 %, distance au nid 3, réserve restante 3, vitesse 2 et coût 1. Premier tour : retour de 2, réserve 1, distance restante 1. Deuxième tour : trajet de 1, arrivée à zéro, puis plein à 20. Avec seulement 1 unité au départ à distance 3, la tortue meurt après 1 unité de trajet.

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
