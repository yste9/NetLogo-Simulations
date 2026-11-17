# Une vie de tortue - v4

**Consignes p. 33 :** ajouter des obstacles de couleur distincte, les éviter et disposer d'un paramètre de nombre d'obstacles. Cette version reprend v3, couleurs, compteurs et ravitaillement inclus.

## Obstacles

Le curseur `nb-obstacles` varie de 0 à 2600 par pas de 1, défaut **100**. Ce défaut et la plage sont des choix de réalisation : la page 33 n'impose pas de valeur. Les autres réglages reprennent les défauts de v3.

INITIALISE choisit exactement ce nombre de patches distincts au hasard. Le nid est exclu et reste noir. Les obstacles sont gris, le terrain libre marron clair. Le booléen `obstacle?` décrit la collision : la couleur n'est pas utilisée comme état logique. Changer le nombre d'obstacles nécessite INITIALISE.

## Évitement et limites

Le cap souhaité vient de l'exploration ou du retour au nid. Si le trajet est bloqué, la tortue essaie successivement les écarts 0, +15, -15, +30, -30, …, +165, -165, 180 degrés ; elle retient le premier trajet libre de la longueur demandée. L'ordre privilégie légèrement la droite en cas d'égalité. Si aucun trajet proposé ne convient, elle reste immobile sans coût énergétique. Le dernier pas reste limité par l'énergie disponible.

Le reporter `trajet-libre?` parcourt les cases coupées par **tout le segment**, en calculant les distances aux prochaines frontières horizontales et verticales (parcours de grille DDA). Ainsi, une vitesse élevée ne permet pas de sauter une case obstacle. Les traversées de bord utilisent les patches raccordés du monde torique. Lorsqu'un segment passe exactement par un coin, les cases latérales doivent aussi être libres : c'est une convention conservatrice pour empêcher de se faufiler entre deux obstacles diagonaux.

L'évitement est **local** ; il ne calcule pas un chemin global vers le nid. Il peut produire un détour, un cycle, un blocage ou un décès avant le retour. Un agent encerclé peut rester vivant indéfiniment puisqu'il ne bouge pas et ne consomme pas. Le cours demande un évitement sans en imposer l'algorithme : ces décisions sont documentées pour permettre la discussion pédagogique.

Avec 0 obstacle, l'algorithme accepte immédiatement le cap souhaité. Avec 2600 obstacles, seul le nid reste libre. Ne pas attendre une extinction systématique dans ce dernier cas.

Voir [la v3](../v3/README.md) pour le seuil en pourcentage, le tirage de réserve individuelle et la priorité du plein à l'arrivée.

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
