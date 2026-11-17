;; Une vie de tortue - v4. Cours Pierre Chauvet, page 33.
;; Les sliders declarent les parametres globaux.
;; Le nid est fige au setup pour qu'un changement de slider ne le deplace pas en cours de route.
globals [ nid-x nid-y ]
turtles-own [ energie energie-init retour? ]
patches-own [ morts obstacle? ]

to setup
  clear-all
  set nid-x x-nid
  set nid-y y-nid
  initialise-patches
  initialise-tortues
  reset-ticks
end

to initialise-patches
  ask patches [
    set obstacle? false
    set morts 0
    set pcolor 38
    set plabel ""
    set plabel-color white
  ]
  ;; Le nid reste toujours libre ; exactement nb-obstacles patches distincts.
  let candidats patches with [not (pxcor = nid-x and pycor = nid-y)]
  ask n-of nb-obstacles candidats [ set obstacle? true set pcolor gray ]
  ask patch nid-x nid-y [ set pcolor black ]
end

to initialise-tortues
  set-default-shape turtles "turtle"
  create-turtles nb-tortues [
    setxy nid-x nid-y
    ;; Capture p.32 : reserve comprise dans la moitie haute du maximum.
    ;; max 1 evite random 0 lorsque energie-max vaut 1.
    let demi max (list 1 (floor (energie-max / 2)))
    set energie-init demi + random demi
    set energie energie-init
    set retour? false
    actualiser-couleur
  ]
end

to go
  if not any? turtles [ stop ]
  ask turtles [ deplacer-et-consommer ]
  tick
end

to deplacer-et-consommer
  if energie <= 0 [ mourir ]
  if energie < (energie-seuil-retour / 100) * energie-init [ set retour? true ]
  let distance-voulue 0
  ifelse retour? [
    ;; Le plus court trajet sur le monde torique est utilise.
    let distance-nid distancexy nid-x nid-y
    if distance-nid > 1.0E-9 [ facexy nid-x nid-y ]
    set distance-voulue min (list vitesse-max distance-nid)
  ] [
    set distance-voulue random (vitesse-max + 1)
    if distance-voulue > 0 [
      ;; Angle entier dans [-n, n], bornes incluses.
      rt (random (2 * angle-deplacement + 1) - angle-deplacement)
    ]
  ]
  let distance-parcourue min (list distance-voulue (energie / energie-par-case))
  avancer-prudemment distance-parcourue
  ;; L'arrivee au nid et le plein sont traites avant la mort : energie exactement 0 acceptee a l'arrivee.
  if distancexy nid-x nid-y <= 1.0E-9 [
    setxy nid-x nid-y
    set energie energie-init
    set retour? false
  ]
  if energie <= 0 [ mourir ]
  actualiser-couleur
end

to avancer-prudemment [longueur]
  if longueur <= 0 [ stop ]
  let cap-souhaite heading
  ;; Premiere direction libre dans un eventail autour du cap souhaite.
  ;; Sans trajet libre de cette longueur, repos sans consommation.
  let angles (list 0 15 -15 30 -30 45 -45 60 -60 75 -75 90 -90 105 -105 120 -120 135 -135 150 -150 165 -165 180)
  let trouve? false
  foreach angles [ angle ->
    if not trouve? [
      set heading cap-souhaite + angle
      if trajet-libre? longueur [ set trouve? true ]
    ]
  ]
  ifelse trouve? [
    forward longueur
    set energie max (list 0 (energie - longueur * energie-par-case))
  ] [ set heading cap-souhaite ]
end

to-report trajet-libre? [longueur]
  ;; Parcours exact de toutes les cellules coupees par le segment (grille DDA).
  ;; Ne se limite pas a la case d'arrivee : aucun saut d'obstacle a grande vitesse.
  let cx floor (xcor + 0.5)
  let cy floor (ycor + 0.5)
  if [obstacle?] of patch cx cy [ report false ]
  let composante-x sin heading
  let composante-y cos heading
  if abs composante-x < 1.0E-12 [ set composante-x 0 ]
  if abs composante-y < 1.0E-12 [ set composante-y 0 ]
  let sx 0 let sy 0
  if composante-x > 0 [ set sx 1 ]
  if composante-x < 0 [ set sx -1 ]
  if composante-y > 0 [ set sy 1 ]
  if composante-y < 0 [ set sy -1 ]
  let tx 1.0E20 let ty 1.0E20
  let pas-x 1.0E20 let pas-y 1.0E20
  if sx != 0 [
    set tx ((cx + 0.5 * sx - xcor) / composante-x)
    set pas-x 1 / abs composante-x
  ]
  if sy != 0 [
    set ty ((cy + 0.5 * sy - ycor) / composante-y)
    set pas-y 1 / abs composante-y
  ]
  while [min (list tx ty) <= longueur + 1.0E-10] [
    ifelse abs (tx - ty) < 1.0E-10 [
      ;; Coin : les deux cases laterales doivent aussi etre libres (choix conservateur).
      if [obstacle?] of patch (cx + sx) cy [ report false ]
      if [obstacle?] of patch cx (cy + sy) [ report false ]
      set cx cx + sx set cy cy + sy
      set tx tx + pas-x set ty ty + pas-y
    ] [
      ifelse tx < ty [ set cx cx + sx set tx tx + pas-x ]
                       [ set cy cy + sy set ty ty + pas-y ]
    ]
    if [obstacle?] of patch cx cy [ report false ]
  ]
  report true
end

to actualiser-couleur
  ;; Rouge a faible reserve, vert au plein : proportion de la reserve individuelle.
  let proportion max (list 0 (min (list 1 (energie / energie-init))))
  set color (list (round (255 * (1 - proportion))) (round (210 * proportion)) 0)
end

to mourir
  ask patch-here [
    set morts morts + 1
    set plabel morts
  ]
  die
end
@#$#@#$#@
GRAPHICS-WINDOW
280
10
790
521
-1
-1
10.0
1
10
1
1
1
0
1
1
1
-25
25
-25
25
1
1
1
ticks
30.0

BUTTON
15
15
255
50
INITIALISE
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
15
60
255
95
GO
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
15
110
255
150
nb-tortues
nb-tortues
0
200
20
1
1
tortues
HORIZONTAL

SLIDER
15
165
255
205
x-nid
x-nid
-25
25
0
1
1
NIL
HORIZONTAL

SLIDER
15
220
255
260
y-nid
y-nid
-25
25
0
1
1
NIL
HORIZONTAL

SLIDER
15
275
255
315
vitesse-max
vitesse-max
0
10
2
1
1
cases/tour
HORIZONTAL

SLIDER
15
330
255
370
energie-max
energie-max
1
100
50
1
1
energie
HORIZONTAL

SLIDER
15
385
255
425
energie-par-case
energie-par-case
0.1
5
1
0.1
1
energie/case
HORIZONTAL

SLIDER
15
440
255
480
angle-deplacement
angle-deplacement
0
180
100
1
1
NIL
HORIZONTAL

SLIDER
15
495
255
535
energie-seuil-retour
energie-seuil-retour
0
100
30
1
1
NIL
HORIZONTAL

SLIDER
15
550
255
590
nb-obstacles
nb-obstacles
0
2600
100
1
1
NIL
HORIZONTAL

MONITOR
15
610
255
660
Tortues vivantes
count turtles
0
1
11
@#$#@#$#@
## UNE VIE DE TORTUE - V4
Regler les sliders, cliquer INITIALISE puis GO (continu).
Rouge = faible reserve ; vert = plein. Etiquettes = deces cumules par patch.
Nid noir. Seuil de retour en pourcentage de la reserve individuelle.
Le nid se fixe lors de INITIALISE. Plein a la reserve initiale individuelle.
Obstacles gris : aucun trajet ne peut les traverser. Si aucun cap propose ne convient, repos.
Changer nb-obstacles puis INITIALISE pour regenerer le monde.
Voir README.md pour les conventions et les tests.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 260 120 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 40 120 60 105 75 105 90 105
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
setup
repeat 10 [ go ]
@#$#@#$#@

@#$#@#$#@

@#$#@#$#@

@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@

