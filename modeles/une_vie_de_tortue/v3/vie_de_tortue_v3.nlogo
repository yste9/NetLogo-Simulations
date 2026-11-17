;; Une vie de tortue - v3. Cours Pierre Chauvet, pages 31-32.
;; Les sliders declarent les parametres globaux.
;; Le nid est fige au setup pour qu'un changement de slider ne le deplace pas en cours de route.
globals [ nid-x nid-y ]
turtles-own [ energie energie-init retour? ]
patches-own [ morts ]

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
    set morts 0
    set pcolor 38
    set plabel ""
    set plabel-color white
  ]
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
  forward longueur
  set energie max (list 0 (energie - longueur * energie-par-case))
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

MONITOR
15
555
255
605
Tortues vivantes
count turtles
0
1
11
@#$#@#$#@
## UNE VIE DE TORTUE - V3
Regler les sliders, cliquer INITIALISE puis GO (continu).
Rouge = faible reserve ; vert = plein. Etiquettes = deces cumules par patch.
Nid noir. Seuil de retour en pourcentage de la reserve individuelle.
Le nid se fixe lors de INITIALISE. Plein a la reserve initiale individuelle.
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

