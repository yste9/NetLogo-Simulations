# Démonstration de souris

Exemple des pages 39–40. Ouvrir `Test_EvtSouris.nlogo`, cliquer INITIALISE puis activer GO-IHM en continu. Un clic ou un glisser dans la vue peint les patches en blanc. Le reste du monde est noir. Un second clic sur GO-IHM arrête l'interaction.

Les moniteurs affichent la présence du pointeur et ses coordonnées. Les coordonnées ne doivent être interprétées que lorsque la souris est dans la vue. `mouse-inside?` et `mouse-down?` contrôlent l'action ; `patch mouse-xcor mouse-ycor` sélectionne la case. Le compteur de ticks n'avance pas : il s'agit d'une boucle d'interaction, pas d'une dynamique temporelle.

Le chargement et l'appel sans clic sont testés avec NetLogo. Les clics et glissés restent à vérifier manuellement. Cet exemple prépare l'éditeur de ville : [validation](../../../documentation/validation-exercices.md).
