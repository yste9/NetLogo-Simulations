;; Predators !!! - cours pages 37-38 ; comportements complementaires documentes.
breed [moutons mouton]
breed [predators predator]
turtles-own [sante age]
patches-own [herbe]

to setup
  clear-all
  ask patches [set herbe 50 + random 51 recolorer-herbe]
  set-default-shape moutons "sheep"
  create-moutons nb-moutons-init [
    setxy random-xcor random-ycor
    set color white set sante 100 set age 0
  ]
  set-default-shape predators "predator"
  create-predators nb-predators-init [
    setxy random-xcor random-ycor
    set color red set sante 100 set age 0
  ]
  reset-ticks
  tracer
end

to go
  ;; L'herbe peut continuer a pousser apres disparition des animaux.
  deplacer-moutons
  nourrir-moutons
  vie-moutons
  chasser-predators
  vie-predators
  croitre-herbe
  tick
  tracer
end

to deplacer-moutons
  ask moutons [
    if [herbe] of patch-here < seuil-herbe-deplacement [
      set heading random 360 forward 1
    ]
  ]
end

to nourrir-moutons
  ;; ask sequentiel : les agents partagent et epuisent la meme ressource.
  ask moutons [
    ifelse [herbe] of patch-here >= conso-herbe [
      ask patch-here [set herbe herbe - conso-herbe]
      set sante min (list 100 (sante + 1))
    ] [ set sante sante - conso-herbe ]
  ]
end

to vie-moutons
  ask moutons [
    set age age + 1
    if sante <= 0 [die]
    ;; Choix explicite : une sante d'au moins 50 est necessaire a la reproduction.
    if sante >= 50 and random-float 1 < proba-reproduction [
      hatch-moutons 1 [set age 0 set sante 50 set heading random 360]
      set sante floor (sante * 0.75)
    ]
    ;; Reprise de la mortalite par malnutrition illustree page 36.
    if sante < 10 [if random 10 > sante [die]]
    if random-float 1 < proba-mort-naturelle [die]
  ]
end

to croitre-herbe
  ask patches [
    set herbe min (list 100 (herbe + croissance-herbe))
    recolorer-herbe
  ]
end

to recolorer-herbe
  ifelse herbe <= 0 [set pcolor 38] [set pcolor scale-color green herbe 110 0]
end

to tracer
  set-current-plot "Courbes"
  set-current-plot-pen "Moutons" plotxy ticks count moutons
  set-current-plot-pen "Herbe" plotxy ticks mean [herbe] of patches
  set-current-plot-pen "Predateurs" plotxy ticks count predators
end

to chasser-predators
  ask predators [
    set sante sante - 1 ;; metabolisme par tour, choix de realisation
    if sante <= 0 [die]
    ifelse sante < seuil-chasse [
      let proies moutons in-radius rayon-vision-predator
      ifelse any? proies [
        let cible min-one-of proies [distance myself]
        if distance cible > 0 [face cible]
        forward min (list vitesse-predator (distance cible))
      ] [set heading random 360 forward vitesse-predator]
      ;; Au plus une proie sur la meme case ; jamais de predation a distance.
      let proie one-of moutons-here
      if proie != nobody [ask proie [die] set sante min (list 100 (sante + 50))]
    ] [rt (random 91 - 45) forward vitesse-predator]
  ]
end

to vie-predators
  ask predators [
    set age age + 1
    if sante >= 50 and random-float 1 < proba-repro-predator [
      hatch-predators 1 [set age 0 set sante 50 set heading random 360]
      set sante floor (sante * 0.75)
    ]
    if random-float 1 < proba-mort-predator [die]
  ]
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
nb-moutons-init
nb-moutons-init
0
200
100
1
1
NIL
HORIZONTAL

SLIDER
15
160
255
200
seuil-herbe-deplacement
seuil-herbe-deplacement
0
100
25
1
1
NIL
HORIZONTAL

SLIDER
15
210
255
250
conso-herbe
conso-herbe
1
20
6
1
1
NIL
HORIZONTAL

SLIDER
15
260
255
300
croissance-herbe
croissance-herbe
0
10
2
0.1
1
NIL
HORIZONTAL

SLIDER
15
310
255
350
proba-reproduction
proba-reproduction
0
1
0.002
0.001
1
NIL
HORIZONTAL

SLIDER
15
360
255
400
proba-mort-naturelle
proba-mort-naturelle
0
1
0.0001
0.0001
1
NIL
HORIZONTAL

MONITOR
15
420
255
465
Moutons
count moutons
2
1
11

PLOT
810
15
1230
315
Courbes
ticks
effectifs / herbe moyenne
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"Moutons" 1.0 0 105 true "" ""
"Herbe" 1.0 0 55 true "" ""
"Predateurs" 1.0 0 15 true "" ""

SLIDER
810
350
1010
390
nb-predators-init
nb-predators-init
0
100
10
1
1
NIL
HORIZONTAL

SLIDER
1030
350
1230
390
rayon-vision-predator
rayon-vision-predator
0
10
4
1
1
NIL
HORIZONTAL

SLIDER
810
405
1010
445
seuil-chasse
seuil-chasse
0
100
30
1
1
NIL
HORIZONTAL

SLIDER
1030
405
1230
445
vitesse-predator
vitesse-predator
0
5
2
0.1
1
NIL
HORIZONTAL

SLIDER
810
460
1010
500
proba-repro-predator
proba-repro-predator
0
1
0.0002
0.0001
1
NIL
HORIZONTAL

SLIDER
1030
460
1230
500
proba-mort-predator
proba-mort-predator
0
1
0.0001
0.0001
1
NIL
HORIZONTAL

MONITOR
15
475
255
520
Predateurs
count predators
2
1
11
@#$#@#$#@
## predators_v0
Voir README.md. Modele NetLogo natif du cours Pierre Chauvet.
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

sheep
false
0
Circle -1 true true 65 75 150
Circle -1 true true 35 100 100
Circle -1 true true 135 95 100
Rectangle -7500403 true false 70 190 95 255
Rectangle -7500403 true false 175 190 200 255
Circle -7500403 true false 200 100 75
Circle -16777216 true false 242 115 10

predator
true
0
Polygon -7500403 true true 150 15 220 90 205 190 250 260 180 245 150 210 120 245 50 260 95 190 80 90
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
setup
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

