# Validation de v1

Tests réellement exécutés dans le moteur officiel NetLogo 7.0.4. Le programme `CheckV1.java` charge les fichiers `.nlogo`, transmet des commandes au moteur et contrôle les résultats. Il ne recode pas la simulation.

## Résultats automatiques

- Chargement et compilation du modèle v1, y compris les variables globales déclarées par les sliders : réussis.
- Six valeurs par défaut vérifiées à l'ouverture : 30, 0, 0, 2, 20 et 1.
- Comparaison de 101 états de v0 et v1, aux réglages par défaut et à graine identique : ticks et listes de tortues (identifiant, position, cap, énergie) exactement identiques. La v1 conserve la dynamique de v0.
- Extinction dans cet essai via API au tick 22 ; 100 appels supplémentaires à GO laissent le tick inchangé. Le protocole via API est distinct du précédent essai BehaviorSpace v0 : le nombre 23 du rapport v0 ne sert pas de référence de réussite ici. Le contrôle pertinent est l'égalité des deux versions dans un même protocole.
- Réglages personnalisés : 12 agents au nid (-25,25), énergie maximale 1, coût 0,1, vitesse 0. Toutes les valeurs sont conservées par `setup`. Après 25 tours : mêmes positions, mêmes réserves et même effectif.
- Changement de vitesse à 10 et de coût à 5 sans réinitialisation : 1200 mises à jour contrôlées. Distance bornée et coût proportionnel au trajet, sans gain d'énergie. Les agents reçoivent une réserve de test de 10000 pour pouvoir contrôler leurs états après chaque déplacement.
- Bornes hautes : 200 agents au nid (25,-25), réserves entre 1 et 100.
- Effectif initial nul : 10 appels à GO sans agent ni progression du temps.

Tous ces contrôles ont terminé sans erreur, avec un code de sortie 0. La graine 1711 sert à reproduire le protocole de comparaison, pas à imposer une durée d'extinction au modèle.

## Reproduire

Dans PowerShell, depuis le dossier `documentation`, lancer `./valider-v1.ps1`. Adapter `-NetLogoDir` à l'installation si nécessaire. Ce script utilise le Java fourni avec NetLogo et sauvegarde la sortie dans `resultats-v1.txt`.

## Interface : vérifications statiques et manuelles

Le fichier comporte une vue avec ticks, INITIALISE, GO continu, six sliders et un moniteur dont le reporter est `count turtles`. Les noms, valeurs initiales, plages et pas sont définis dans le fichier `.nlogo`. Le chargement de ces contrôles est vérifié par le moteur. **Le rendu visuel et les clics n'ont pas été testés automatiquement.**

Pour terminer la vérification dans l'application :

1. Ouvrir v1 ; contrôler la lisibilité des six sliders, des boutons, de la vue et du moniteur.
2. Régler l'effectif sur 12, le nid sur (-10,10), l'énergie maximale sur 1 ; cliquer INITIALISE. Le moniteur doit afficher 12 et les agents doivent se superposer au nid.
3. Vérifier que les sliders conservent ces valeurs après INITIALISE.
4. Cliquer GO à vitesse lente : l'effectif ne doit pas augmenter. Cliquer à nouveau GO : les ticks doivent se stabiliser.
5. Essayer la vitesse 0 après réinitialisation : aucun mouvement ni décès, mais les ticks progressent pendant GO.
6. Régler l'effectif à 0 puis INITIALISE et GO : moniteur à 0 et ticks à 0.

Ces contrôles manuels sont fournis comme procédure, pas présentés comme déjà réussis.
