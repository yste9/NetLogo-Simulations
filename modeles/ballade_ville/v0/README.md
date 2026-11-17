# Ballade en Ville - v0

Exercice des pages 43–44 : charger un plan texte à l'aide d'une boîte de dialogue. Noir = bâtiment fermé ; blanc = rue ou espace ouvert. Le modèle conserve l'orthographe « Ballade » du cours.

## Lancer

1. Ouvrir `ballade_ville_v0.nlogo` dans NetLogo, puis EFFACER / INITIALISE.
2. Cliquer EXEMPLE FOURNI ou OUVRIR UNE VILLE pour sélectionner un fichier créé par l'éditeur.
3. Régler `nombre-personnes` puis cliquer CREER LES PROMENEURS.
4. Cliquer GO ; un second clic suspend.

Le curseur va de 0 à 200, défaut 50 comme la capture p. 43. Le modèle crée les agents sur des cases blanches et ne permet pas de promenade avant le chargement d'une ville. Changer l'effectif nécessite CREER LES PROMENEURS, qui remet le temps à zéro. Le chargement d'une nouvelle ville supprime les anciens promeneurs et remet les ticks à zéro.

## Règles et conventions

Le cours présente le format et le chargement, sans spécifier complètement les déplacements. Ici, les promeneurs choisissent à chaque tick une case **cardinale voisine** libre ; ils avancent de centre de patch à centre de patch. Ils ne traversent donc pas un bâtiment et ne coupent pas un coin diagonal. Sans sortie libre, ils restent sur place. Plusieurs agents peuvent partager une case. Le monde de 51×51 patches est borné, sans raccordement des bords. Ces choix sont documentés pour être distingués des consignes explicites.

Chaque paire `x y` du fichier désigne un patch noir, coordonnées entières de -25 à 25. Le chargeur utilise `file-read`, valide toutes les données avant de modifier le monde et ferme le fichier même en cas d'erreur. Un fichier vide est valide, les doublons sont sans effet supplémentaire. Un fichier invalide ou une annulation conserve l'état précédent. Une ville entièrement noire se charge, mais ne permet pas de créer des promeneurs : un message l'indique.

`filename` et `ok?` reprennent les variables montrées p. 44. Le reporter `neighbors4` permet d'obtenir les quatre voisins cardinaux ; `move-to` place l'agent au centre de la destination choisie. Les boîtes de dialogue doivent être vérifiées manuellement, mais les lectures, la compatibilité avec l'éditeur et l'absence d'occupation des murs sont testées : [validation](../../../documentation/validation-exercices.md).
