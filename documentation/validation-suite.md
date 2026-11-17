# Validation des versions v2, v3 et v4

## Méthode

Contrôles réellement exécutés avec le moteur officiel **NetLogo 7.0.4**, via son API `HeadlessWorkspace`. `CheckSuite.java` transmet des commandes NetLogo, lit les reporters et déclenche une erreur lorsqu'un invariant n'est pas respecté. Aucune simulation Python ou JavaScript ne remplace NetLogo. Les fichiers v0 et v1 sont conservés.

Reproduire depuis `documentation` avec `./valider-suite.ps1` dans PowerShell ; adapter `-NetLogoDir` si nécessaire. La sortie complète est enregistrée dans `resultats-suite.txt`. Le Java est celui inclus dans l'installation NetLogo. Les aperçus PNG ont été exportés par `export-view` dans NetLogo après `random-seed 1711 setup repeat 15 [go]`, aux valeurs par défaut propres à chaque version ; ils ont été examinés visuellement.

## Contrôles ciblés

| Contrôle | Versions | Résultat |
|---|---|---|
| Chargement et compilation des `.nlogo`, avec leurs widgets et variables de sliders | v2, v3, v4 | Réussi |
| Création au nid, réserve positive et compteur des morts nul | v2, v3, v4 | Réussi |
| Couleur au plein `[0 210 0]` et à moitié `[128 105 0]` | v2, v3, v4 | Réussi |
| Vingt tortues forcées à énergie zéro : vingt décès sur le patch du nid et étiquette 20 | v2, v3, v4 | Réussi |
| Réinitialisation des morts et des étiquettes ; arrêt du temps en monde vide | v2, v3, v4 | Réussi |
| Retour à vitesse maximale, dernier trajet limité à la distance restante | v3, v4 sans obstacles pour ce contrôle | Réussi |
| Arrivée à zéro énergie suivie du plein à la réserve individuelle ; mort lorsque le nid est hors de portée énergétique | v3, v4 sans obstacles | Réussi |
| Énergie maximale de 1, angle nul et nid figé pendant GO | v3, v4 sans obstacles | Réussi |
| Cent déplacements exploratoires : rotation bornée par 100°, distance bornée et coût proportionnel | v3, v4 sans obstacles | Réussi |
| Génération exacte de 100 obstacles, nid libre et aucune tortue sur un obstacle | v4 | Réussi |
| Obstacle intermédiaire sur un segment long de 4, évitement et position finale libre | v4 | Réussi |
| Obstacle au raccord torique, contact par un coin diagonal | v4 | Réussi |
| Encerclement : immobilité sans consommation ; 2600 obstacles laissant le seul nid libre | v4 | Réussi |

Le contrôle d'énergie en exploration utilise une réserve de test de 1000 et un départ hors du nid pour isoler la consommation. Le test du retour utilise une réserve initiale de 20, une réserve actuelle de 3, une distance de 3, un coût de 1 et une vitesse de 2. Ces réglages de test ne remplacent pas les défauts enregistrés dans les modèles.

## Essais sur trois graines

Pour chaque version : 20 agents, nid (0,0), vitesse 2, énergie maximale 50 et coût 1. Pour v3/v4 : angle 100°, seuil 30 %. Pour v4 : 100 obstacles. Cent appels à GO sont effectués pour chacune des graines 1711, 42 et 7. Lorsque l'extinction survient plus tôt, les appels suivants n'avancent plus le temps.

À chaque appel sont vérifiés le bilan `vivantes + morts = 20`, la positivité des réserves des survivantes, leur borne individuelle maximale et les étiquettes des patches ayant enregistré un décès. En v4, aucune tortue ne doit occuper un obstacle. Les réserves peuvent remonter en v3/v4 lors d'un plein : une décroissance stricte ne serait donc pas un invariant correct.

| Version | Graine | Survivantes après les 100 appels | Dernier tick atteint |
|---|---:|---:|---:|
| v2 | 1711 | 0 | 57 |
| v2 | 42 | 0 | 52 |
| v2 | 7 | 0 | 53 |
| v3 | 1711 | 6 | 100 |
| v3 | 42 | 5 | 100 |
| v3 | 7 | 6 | 100 |
| v4 | 1711 | 4 | 100 |
| v4 | 42 | 3 | 100 |
| v4 | 7 | 3 | 100 |

Ces données proviennent des exécutions consignées, avec les réglages communs de test ci-dessus. Ce ne sont pas des valeurs théoriques imposées par le cours. Trois graines ne suffisent pas à une conclusion statistique sur l'effet des obstacles ; le tirage initial, le protocole d'appel et l'ordre aléatoire des agents influencent les trajectoires.

## Interprétation et limites

En v2, les réserves ne sont jamais rechargées ; l'extinction est attendue avec vitesse et coût positifs, sans durée maximale déterministe à cause des repos aléatoires. En v3, le retour peut échouer si le seuil est trop bas ; un plein réussi autorise de nouveaux cycles. En v4, l'évitement local peut occasionner des détours ou laisser un agent bloqué sans consommation. L'extinction n'est donc pas une condition de réussite obligatoire pour v3/v4.

Les tests géométriques ciblent notamment le saut d'obstacle, le raccord et le coin. Ils ne constituent pas une preuve formelle de tous les trajets possibles. Les aperçus confirment le rendu du monde (couleurs, nid et obstacles), **pas les clics ni la disposition complète de l'interface**.

## Vérifications manuelles de l'interface

1. Ouvrir chaque `.nlogo` dans l'application ; vérifier la présence de la vue, des ticks, des boutons et du moniteur d'effectif. v2 possède six sliders ; v3 en possède huit ; v4 neuf.
2. Cliquer INITIALISE puis GO, ralentir l'affichage et vérifier l'évolution des couleurs. En v2, les étiquettes apparaissent aux emplacements des décès.
3. Suspendre avec GO et vérifier que les ticks restent stables.
4. En v3/v4, inspecter une tortue pour voir `energie`, `energie-init` et `retour?` ; contrôler le retour vers le nid noir et le plein.
5. En v4, régler `nb-obstacles` puis INITIALISE : vérifier les cases grises et le nid libre. Essayer 0, 100 et 2600 ; à 2600 les agents restent au nid.
6. Si la colonne de paramètres dépasse la hauteur disponible en v4, agrandir la fenêtre ou faire défiler l'onglet Interface.

Les clics de ces étapes restent à effectuer par l'utilisateur ; ils ne sont pas présentés comme des tests automatisés réussis.
