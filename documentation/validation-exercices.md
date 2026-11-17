# Validation des exercices suivants

Exécutions réelles avec le moteur officiel **NetLogo 7.0.4**. Reproduire depuis ce dossier avec `./valider-exercices.ps1` dans PowerShell, en adaptant `-NetLogoDir` à l'installation. `CheckExercices.java` pilote NetLogo, sans recoder ses dynamiques. Le journal complet est dans `resultats-exercices.txt`.

## Contrôles réussis

- Les cinq modèles chargent et compilent avec leurs interfaces sérialisées.
- Moutons : initialisation, partage de la même réserve d'herbe, consommation de la quantité exactement disponible, plafond de croissance à 100, reproduction certaine d'un parent sain, âge et santé du nouveau-né, restriction de reproduction à santé insuffisante, mort par faim et mortalité naturelle réglée à 1.
- Prédateurs : contrôles des moutons hérités, chasse d'une proie à distance 2 par un prédateur de santé 20, gain de santé de 50 après le coût métabolique de 1, disparition sans proie, reproduction et mortalité naturelle.
- Éditeur : blocs 1×1 et 2×2, troncature d'un bloc au bord sans raccordement, sauvegarde puis relecture de six cases noires, refus d'un nom existant. Quatre fichiers invalides sont rejetés sans changer la ville : paire incomplète, coordonnée hors du monde, chaîne de texte et coordonnée décimale. Un fichier vide est accepté.
- Promenade : lecture de la ville réellement sauvegardée par l'éditeur, 50 agents restant sur des cases libres pendant 200 tours, puis immobilité sur une case blanche encerclée de murs. La ville exemple fournie est également chargée.
- Souris : l'appel GO-IHM sans clic ne modifie pas le monde et n'avance pas les ticks. Cela ne valide pas un clic physique.

## Mesures réellement obtenues

Essais de 100 tours avec 75 moutons, consommation 8, croissance 1, reproduction 0,001 et mort naturelle 0,0001. Pour Predators : 10 prédateurs, vision 4, seuil 30, vitesse 2, reproduction 0,0002 et mort naturelle 0,0001. Ce protocole commun diffère des défauts enregistrés dans Predators, qui reprennent la capture p. 38.

| Modèle | Graine | Moutons au tick 100 | Prédateurs | Herbe moyenne (arrondie) |
|---|---:|---:|---:|---:|
| Paisibles moutons | 1711 | 82 | — | 89,3083 |
| Paisibles moutons | 42 | 83 | — | 88,8739 |
| Paisibles moutons | 7 | 80 | — | 89,3345 |
| Predators | 1711 | 75 | 10 | 89,4729 |
| Predators | 42 | 70 | 10 | 90,0684 |
| Predators | 7 | 72 | 11 | 89,5959 |

À chaque tour sont vérifiés `0 <= herbe <= 100`, `0 < sante <= 100` pour les survivants et un âge non négatif. Ces quelques essais ne prouvent ni équilibre écologique ni oscillations stables. Les résultats dépendent des règles documentées, du protocole et des tirages.

## Portée et vérifications manuelles restantes

Les aperçus sont exportés par NetLogo dans les fichiers `apercu-paisibles_moutons.png`, `apercu-predators.png`, `apercu-creation_ville.png`, `apercu-ballade_ville.png` et `apercu-test_souris.png`. Ils montrent le monde, pas l'ensemble des widgets.

Les clics de souris, les boîtes `user-file` / `user-new-file`, le rendu complet des curseurs et le bouton continu doivent encore être vérifiés dans l'application :

1. Ouvrir chaque fichier et essayer INITIALISE, GO et son arrêt ; vérifier les moniteurs et les courbes des animaux.
2. Dans Test_EvtSouris, cliquer puis glisser dans la vue ; sortir de la vue ne doit plus peindre.
3. Dans Création Ville, dessiner en tailles 1 et 2 ; sauvegarder vers un nouveau `.txt`, annuler une boîte de dialogue puis vérifier que le dessin est conservé.
4. Dans Ballade en Ville, charger ce fichier via la boîte de dialogue, créer les promeneurs et vérifier qu'ils restent dans les rues. Essayer le fichier exemple fourni.

Les fixtures de fichiers sont créées dans un sous-dossier temporaire `validation-villes-*` de ce dossier. Elles sont exclues de Git et peuvent être régénérées par le script.
