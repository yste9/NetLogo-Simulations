;; Une vie de tortue - v1 uniquement. Cours Pierre Chauvet, pages 27-29.
;; Les six sliders declarent les variables globales de l'interface.
;; Ne pas les redeclarer dans globals : NetLogo signalerait un doublon.
;; nb-tortues ; x-nid ; y-nid ; vitesse-max ; energie-max ; energie-par-case.
turtles-own [ energie ] ;; chaque tortue possede sa propre reserve

to setup
  clear-all
  ;; clear-all conserve les valeurs des sliders.
  initialise-tortues
  reset-ticks
end

to initialise-tortues
  set-default-shape turtles "turtle"
  create-turtles nb-tortues [
    set color green
    setxy x-nid y-nid
    set energie 1 + random energie-max ;; entier de 1 a energie-max inclus
  ]
end

to go
  if not any? turtles [ stop ]
  ask turtles [ deplacer-et-consommer ]
  tick
  ;; Au prochain appel, le monde vide arrete le bouton sans avancer le temps.
end

to deplacer-et-consommer
  if energie <= 0 [ die ]
  ;; random exclut sa borne : tirage entier de 0 a vitesse-max inclus.
  let distance-tiree random (vitesse-max + 1)
  if distance-tiree > 0 [
    set heading random 360
    ;; Choix explicite : ne pas parcourir une distance sans energie suffisante.
    let distance-parcourue min (list distance-tiree (energie / energie-par-case))
    forward distance-parcourue
    ;; Le monde est torique : traverser un bord conserve la distance parcourue.
    set energie max (list 0 (energie - distance-parcourue * energie-par-case))
  ]
  if energie <= 0 [ die ] ;; disparition au tour de l'epuisement
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
30
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
20
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

MONITOR
15
445
255
495
Tortues vivantes
count turtles
0
1
11
@#$#@#$#@
## UNE VIE DE TORTUE - V1
Page 29 du cours Pierre Chauvet : parametres via sliders et moniteur d'effectif.
Regler les six sliders puis cliquer INITIALISE et GO (continu).
Effectif, nid et energie-max servent au prochain INITIALISE.
Vitesse et cout s'appliquent des le prochain tour si modifies pendant GO.
Suspendre GO avant de changer les reglages pour une experience interpretable.
Le comportement des tortues est celui de v0. Voir README.md.
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

