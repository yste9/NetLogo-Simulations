# Predators !!! - v0

Modèle des pages 37–38, qui reprend [De paisibles moutons](../../paisibles_moutons/v0/README.md) et ajoute des prédateurs rouges. Ouvrir `predators_v0.nlogo`, puis INITIALISE et GO. Le second clic sur GO suspend. Les deux effectifs et l'herbe moyenne apparaissent dans le graphique et les moniteurs.

## Paramètres

Les défauts lisibles p. 38 sont repris : 100 moutons, seuil d'herbe 25, consommation 6, croissance 2, reproduction des moutons 0,002 et mortalité naturelle 0,0001. Les réglages des prédateurs sont :

| Curseur | Défaut p. 38 | Plage choisie |
|---|---:|---:|
| nb-predators-init | 10 | 0–100 |
| rayon-vision-predator | 4 | 0–10 |
| seuil-chasse | 30 | 0–100 |
| vitesse-predator | 2 | 0–5 |
| proba-repro-predator | 0,0002 | 0–1 |
| proba-mort-predator | 0,0001 | 0–1 |

Les probabilités sont des proportions par tour. Les effectifs sont appliqués au setup ; les autres réglages s'appliquent pendant GO. Les six réglages des prédateurs sont placés à droite, sous le graphique ; agrandir la fenêtre pour les voir.

## Choix de comportement

La page 37 indique le besoin de manger des moutons pour survivre et se reproduire, sans fournir le code de chasse. Les règles suivantes sont donc des **choix explicites de réalisation**, pas une transcription d'un algorithme imposé :

- Chaque prédateur commence à santé 100 et perd 1 par tour ; zéro entraîne la mort.
- Sous `seuil-chasse`, il cherche le mouton visible le plus proche dans le rayon réglé et avance vers lui, au maximum à sa vitesse. Sans cible visible, il explore au hasard.
- Après ce déplacement de chasse, il mange au plus un mouton présent sur le même patch et récupère 50 de santé, sans dépasser 100. Il ne tue pas à distance.
- Au-dessus du seuil, il se déplace vers l'avant avec une rotation entre -45° et +45°.
- Un prédateur de santé au moins 50 peut se reproduire : petit à santé 50 et âge 0, parent à 75 % de sa santé arrondie vers le bas. La mortalité naturelle s'applique ensuite.

Le monde est torique. Un tour réalise les phases des moutons, puis chasse et vie des prédateurs, puis croissance de l'herbe et tracé. Cet ordre et le départage aléatoire des cibles peuvent influencer les résultats. Aucune capacité de charge artificielle n'est ajoutée ; les populations peuvent fluctuer ou s'éteindre. Cent tours de test ne suffisent pas à démontrer un équilibre écologique. Voir [les tests](../../../documentation/validation-exercices.md).
