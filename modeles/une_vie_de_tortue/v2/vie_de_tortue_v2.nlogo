;; Une vie de tortue - v2. Cours Pierre Chauvet, page 30.
;; Les six sliders declarent les variables globales de l'interface.
;; Ne pas les redeclarer dans globals : NetLogo signalerait un doublon.
;; nb-tortues ; x-nid ; y-nid ; vitesse-max ; energie-max ; energie-par-case.
turtles-own [ energie energie-init ]
patches-own [ morts ] ;; deces cumules sur chaque case

to setup
  clear-all
  ;; clear-all conserve les valeurs des sliders.
  initialise-patches
  initialise-tortues
  reset-ticks
end

to initialise-tortues
  set-default-shape turtles "turtle"
  create-turtles nb-tortues [
    set color green
    setxy x-nid y-nid
    set energie-init 1 + random energie-max
    set energie energie-init
    actualiser-couleur
  ]
end

to go
  if not any? turtles [ stop ]
  ask turtles [ deplacer-et-consommer ]
  tick
  ;; Au prochain appel, le monde vide arrete le bouton sans avancer le temps.
end

to deplacer-et-consommer
  if energie <= 0 [ mourir ]
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
  if energie <= 0 [ mourir ]
  actualiser-couleur
end

to initialise-patches
  ask patches [
    set morts 0
    set pcolor 38 ;; fond marron clair comme la capture page 32
    set plabel "" ;; les cases sans mort restent lisibles
    set plabel-color white
  ]
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
## UNE VIE DE TORTUE - V2
Regler les sliders, cliquer INITIALISE puis GO (continu).
Rouge = faible reserve ; vert = plein. Etiquettes = deces cumules par patch.
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

