# Création Ville - v0

Exercice des pages 45–46, utilisant les primitives de souris et de fichiers des pages 39–42.

## Utilisation

1. Ouvrir `creation_ville_v0.nlogo` et cliquer EFFACER / INITIALISE : le terrain devient blanc.
2. Choisir `taille-bloc` 1 ou 2 puis activer DESSINER (CONTINU).
3. Cliquer ou glisser sur la vue : les bâtiments sont noirs. Le bloc 2×2 s'étend vers la droite et vers le haut depuis le patch cliqué, comme dans le cours.
4. Désactiver le bouton continu avant d'enregistrer. SAUVER LA VILLE ouvre une boîte de dialogue ; choisir un **nouveau nom** en `.txt`.
5. Charger ce fichier dans Ballade en Ville avec OUVRIR UNE VILLE. Une ville exemple est également fournie ici dans `ville_exemple.txt`.

Le monde est borné, de -25 à 25 sur chaque axe. Un bloc dépassant un bord est tronqué, sans réapparaître de l'autre côté. La taille du monde et cette gestion des bords sont des choix explicites.

## Fichiers et état

Une ligne contient deux entiers séparés par un espace : `x y`, pour une case noire. Les espaces et sauts de ligne servent de séparateurs, sans en-tête. La sauvegarde trie les patches et ferme le fichier. Elle refuse un nom existant pour empêcher l'ajout implicite de `file-open` à un ancien fichier ; choisir un autre nom pour une nouvelle version. Annuler la boîte de dialogue conserve la ville.

Le bouton OUVRIR permet aussi de modifier une ville existante : c'est l'extension évoquée p. 45. Le chargeur valide l'ensemble du fichier avant de changer la vue, rejette les paires incomplètes, coordonnées non entières ou hors du monde et conserve la ville précédente en cas d'échec. Un fichier vide décrit une ville sans bâtiment. Les doublons sont tolérés : une même case reste noire une seule fois.

`mouse-inside?` et `mouse-down?` pilotent `dessiner`. `peindre-bloc` réalise la modification et peut être testé indépendamment d'une souris physique. `user-new-file` et `user-file` sélectionnent un chemin ; `file-open`, `file-print`, `file-read` et `file-close` assurent l'échange. Il n'y a pas de temps simulé dans cet éditeur ; le compteur reste à zéro.

Les tests de fichiers et de blocs sont réellement exécutés, mais les gestes physiques de souris et les boîtes de dialogue restent à vérifier dans l'application : [validation](../../../documentation/validation-exercices.md).
