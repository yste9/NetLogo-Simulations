# Validation de v0

Exécution réelle le 17 novembre 2026, avec le moteur officiel **NetLogo 7.0.4** installé dans `C:\Program Files\NetLogo 7.0.4`. Aucun moteur de simulation Python ou JavaScript n'a été utilisé. Java sert uniquement à appeler l'API officielle de NetLogo pour le contrôle complémentaire.

Le modèle `.nlogo` a été chargé et compilé par NetLogo. Les six expériences BehaviorSpace intégrées ont terminé avec un code de sortie 0 et sans erreur d'assertion. Les résultats bruts se trouvent dans les CSV de ce dossier. Une exécution complémentaire via l'API vérifie les appels après extinction, car `stop` peut interrompre une séquence de commandes BehaviorSpace avant ses assertions finales.

| Scénario | Contrôle exécuté | Résultat réel |
|---|---|---|
| Initialisation | Effectif 30, coordonnées (0,0), énergie entière entre 1 et 20, tick 0 | Réussi ; graine 1711 : minimum 1, maximum 19 (20 est une borne, pas une valeur nécessairement tirée) |
| Déplacement et coût | 30 agents à réserve de test 10000, 100 tours ; contrôle de la distance et de la variation d'énergie pour chaque agent à chaque tour, tolérance 1e-7 | Réussi ; 3000 mises à jour, effectif constant 30 ; somme finale des réserves 297008 |
| Aléatoire | Plusieurs orientations effectivement observées dans l'essai de déplacement | 28 orientations distinctes au tour 100 ; ce constat ne prouve pas statistiquement l'uniformité |
| Mort | Réserves forcées à zéro, appel de GO | 30 agents au tick 0, aucun au tick 1 |
| Extinction naturelle | Graine 1711, paramètres livrés ; population non croissante | Aucun survivant au tick 23 |
| Monde vide | Aucune tortue, appel de GO | Aucun agent, tick toujours 0 |
| Bord et dernier pas | Déplacement imposé de 2 vers l'est depuis (25,0), puis réserve forcée à 0,5 | Raccord à x=-24 vérifié ; mort au tick 1 avec la graine 1711 |
| Après extinction | Appels à GO après disparition des agents, via API NetLogo | 100 appels supplémentaires : effectif 0 et tick 23 inchangés ; 10 appels depuis un monde initialement vide : tick 0 |

La réserve élevée du test de déplacement sert à conserver chaque agent pour comparer son état avant et après. Elle ne change pas les valeurs par défaut du modèle. Le test de bord isole la topologie, puis vérifie la disparition avec une énergie fractionnaire ; il ne prétend pas être un test statistique de tous les passages de bord.

## Reproduire automatiquement

Depuis ce dossier `documentation`, exécuter le script PowerShell `valider-v0.ps1`. Il appelle le Java déjà inclus dans l'installation NetLogo ; adapter le paramètre `-NetLogoDir` si nécessaire. Les résultats sont régénérés dans ce dossier.

Les expériences sont également accessibles dans **Tools > BehaviorSpace** du modèle. `tests-v0.xml` en conserve une copie lisible. Modifier une expérience dans le modèle implique de synchroniser cette copie.

Le fichier `Check.java` contient le contrôle complémentaire de stabilité après extinction. Ce programme ne calcule aucune dynamique : il transmet `setup` et `go` au moteur NetLogo et lit ses reporters.

## Vérifications statiques

Le modèle comprend `globals`, `turtles-own`, `setup`, `go` et deux sous-procédures d'initialisation ainsi qu'une sous-procédure de déplacement. Les paramètres ont les valeurs lisibles p. 28. L'interface sérialisée contient une vue avec compteur de ticks et deux boutons d'observateur : INITIALISE appelle `setup`, GO appelle `go` en continu. Il n'existe aucun slider ni moniteur. Pas de reproduction, de ravitaillement, d'obstacle, de retour au nid ou de modèle v1-v4.

## Vérifications manuelles à effectuer dans l'application

Les clics et le rendu visuel de l'interface **n'ont pas été testés automatiquement**. L'ouverture et la compilation ont été testées avec le moteur sans interface. Pour compléter la validation :

1. Ouvrir le `.nlogo` avec NetLogo et vérifier la vue, INITIALISE, GO et le compteur de ticks.
2. Cliquer INITIALISE. Dans le centre de commandes, exécuter `show count turtles` (30), `show all? turtles [xcor = x-nid and ycor = y-nid]` (true), puis `show all? turtles [energie >= 1 and energie <= energie-max]` (true).
3. Cliquer GO à vitesse d'affichage lente. Observer la dispersion et l'évolution des ticks. Cliquer de nouveau GO et vérifier que le compteur reste stable : c'est le contrôle manuel de suspension.
4. Relancer GO jusqu'à l'extinction. Vérifier que le bouton cesse sa boucle et que les ticks restent stables. Cliquer INITIALISE pour confirmer le redémarrage.
5. Pour observer un agent, après INITIALISE : `inspect turtle 0`, puis avancer avec `go` dans le centre de commandes. Son énergie ne doit jamais augmenter ; l'inspecteur ne crée pas de moniteur permanent.

Le tick 23 est un résultat reproductible de l'essai enregistré avec la graine 1711 dans NetLogo 7.0.4. Ce n'est pas une durée imposée par le cours, ni une garantie pour d'autres graines ou versions.
