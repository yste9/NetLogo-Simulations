# NetLogo - simulations multi-agents

Projet de Master 2 MIASHS, cours de Pierre Chauvet : dix modèles NetLogo natifs, leurs explications pédagogiques et leurs tests. Les simulations s'exécutent dans l'application officielle NetLogo ; VS Code sert à éditer le projet.

## Choisir un exercice

| Exercice | Fichier et guide | Cours |
|---|---|---|
| Une vie de tortue | [v0](modeles/une_vie_de_tortue/v0/README.md), [v1](modeles/une_vie_de_tortue/v1/README.md), [v2](modeles/une_vie_de_tortue/v2/README.md), [v3](modeles/une_vie_de_tortue/v3/README.md), [v4](modeles/une_vie_de_tortue/v4/README.md) | p. 27–33 |
| De paisibles moutons | [Guide](modeles/paisibles_moutons/v0/README.md) · [Modèle](modeles/paisibles_moutons/v0/paisibles_moutons_v0.nlogo) | p. 34–36 |
| Predators !!! | [Guide](modeles/predators/v0/README.md) · [Modèle](modeles/predators/v0/predators_v0.nlogo) | p. 37–38 |
| Souris | [Guide](modeles/test_souris/v0/README.md) · [Modèle](modeles/test_souris/v0/Test_EvtSouris.nlogo) | p. 39–40 |
| Ballade en Ville | [Guide](modeles/ballade_ville/v0/README.md) · [Modèle](modeles/ballade_ville/v0/ballade_ville_v0.nlogo) | p. 43–44 |
| Création Ville | [Guide](modeles/creation_ville/v0/README.md) · [Modèle](modeles/creation_ville/v0/creation_ville_v0.nlogo) | p. 45–46 |

## Démarrer

1. Ouvrir ce dossier `NetLogo-Simulations` dans VS Code pour lire et modifier les fichiers.
2. Dans NetLogo officiel, choisir **File > Open**, puis `modeles/une_vie_de_tortue/v4/vie_de_tortue_v4.nlogo` pour la version complète avec obstacles, ou le fichier de la version à étudier. Le format historique NetLogo 6.4 est importable dans NetLogo 7.0.4, moteur utilisé pour les tests.
3. Cliquer **INITIALISE**, puis **GO**. Un second clic sur GO suspend la simulation. INITIALISE recommence une expérience à zéro.
4. Pour les tortues, lire le compteur `ticks` dans la vue. Leur arrêt automatique intervient lorsque le monde est vide, sans tick supplémentaire. Les modèles écologiques continuent à faire pousser l'herbe après extinction ; les éditeurs et la démonstration de souris n'avancent pas les ticks.

Le fichier contient déjà la vue, les deux boutons et les formes de tortues. Aucune construction manuelle de l'interface n'est nécessaire. Les contrôles visuels à effectuer dans l'application sont décrits dans la documentation de validation.

Pour éditer dans VS Code : modifier uniquement la première section de code du `.nlogo`, avant le premier séparateur `@#$#@#$#@`, puis enregistrer et rouvrir dans NetLogo. Éviter de modifier simultanément le fichier dans les deux applications. NetLogo 7 peut proposer un enregistrement au nouveau format `.nlogox` : conserver le `.nlogo` livré comme référence.

## Organisation

- `cours/` : référence du cours ; PDF fourni conservé localement et exclu du dépôt public.
- `modeles/une_vie_de_tortue/v0/` : modèle, explications et grille d'observation.
- `modeles/une_vie_de_tortue/v1/` : six curseurs de paramètres, moniteur d'effectif, documentation et grille d'observation.
- `modeles/une_vie_de_tortue/v2/` : couleurs selon la réserve et cumul des décès par patch.
- `modeles/une_vie_de_tortue/v3/` : exploration avec variation du cap, retour au nid et plein individuel.
- `modeles/une_vie_de_tortue/v4/` : obstacles réglables et évitement local avec contrôle du trajet complet.
- `modeles/paisibles_moutons/`, `predators/`, `ballade_ville/`, `creation_ville/`, `test_souris/` : exercices suivants, chacun avec modèle v0, guide et grille d'observation.
- `documentation/` : analyse du cours, validation, scénarios BehaviorSpace et résultats CSV réellement produits.

Voir [les explications de v0](modeles/une_vie_de_tortue/v0/README.md) et [la validation](documentation/validation-v0.md). Aucune extension NetLogo ni bibliothèque supplémentaire n'est nécessaire pour utiliser le modèle.

Pour la suite : [guide v1](modeles/une_vie_de_tortue/v1/README.md) et [validation v1](documentation/validation-v1.md).

Guides supplémentaires : [v2](modeles/une_vie_de_tortue/v2/README.md), [v3](modeles/une_vie_de_tortue/v3/README.md), [v4](modeles/une_vie_de_tortue/v4/README.md). Les conventions qui complètent les pages 30 à 33 et les valeurs choisies par défaut sont signalées dans chaque guide. Voir [les tests v2-v4 et leurs résultats](documentation/validation-suite.md).

Pour les exercices suivants, voir [les tests et résultats](documentation/validation-exercices.md). Tous les modèles ont été chargés et compilés avec NetLogo 7.0.4. Les gestes de souris et boîtes de dialogue restent à vérifier manuellement ; ils ne sont pas présentés comme des tests automatisés réussis.

Le projet n'impose aucune extension NetLogo. Les scripts PowerShell de validation utilisent le Java déjà inclus dans NetLogo. Les choix qui complètent les règles du cours sont signalés dans les guides ; les résultats observés sont séparés des grilles vierges à remplir.
