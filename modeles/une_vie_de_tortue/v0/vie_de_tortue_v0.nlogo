;; Une vie de tortue - v0 uniquement. Cours Pierre Chauvet, pages 15-28.
globals [
  nb-tortues         ;; effectif initial
  x-nid y-nid       ;; les deux coordonnees forment un seul parametre de position
  vitesse-max       ;; distance maximale par tour, en unites de patch
  energie-max       ;; borne superieure de l'energie initiale
  energie-par-case  ;; cout par unite de distance
]
turtles-own [ energie ] ;; chaque tortue possede sa propre reserve

to setup
  clear-all
  initialise-globals
  initialise-tortues
  reset-ticks
end

to initialise-globals
  ;; Valeurs lisibles dans la capture du cours, page 28.
  set nb-tortues 30
  set x-nid 0
  set y-nid 0
  set vitesse-max 2
  set energie-max 20
  set energie-par-case 1
end

to initialise-tortues
  set-default-shape turtles "turtle"
  create-turtles nb-tortues [
    set color green
    setxy x-nid y-nid
    set energie 1 + random energie-max ;; entier de 1 a 20 inclus
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
  ;; random exclut sa borne : + 1 permet de tirer 0, 1 ou 2.
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
180
10
690
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
25
155
60
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
75
155
110
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
@#$#@#$#@
## UNE VIE DE TORTUE - V0
Cours Pierre Chauvet, pages 15-28. Voir README.md pour les choix et les tests.
INITIALISE cree 30 tortues au nid (0,0), avec une energie entiere de 1 a 20.
GO fonctionne en continu ; un second clic permet de suspendre.
Distance tiree : 0, 1 ou 2 ; cout : 1 par unite. Mort immediate a energie nulle.
Le monde de 51 x 51 patches est torique. Aucun slider ni moniteur de v1.
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
<experiments>
  <experiment name="initialisation" repetitions="1" runMetricsEveryStep="true">
    <setup>random-seed 1711 setup
if count turtles != nb-tortues [ error "effectif" ]
if any? turtles with [xcor != x-nid or ycor != y-nid] [error "nid"]
if any? turtles with [energie &lt; 1 or energie &gt; energie-max or energie != floor energie] [error "energie initiale"]
if ticks != 0 [error "ticks initiaux"]</setup>
    <go>go</go>
    <timeLimit steps="1" />
    <metric>count turtles</metric>
    <metric>ticks</metric>
    <metric>min [energie] of turtles</metric>
    <metric>max [energie] of turtles</metric>
  </experiment>
  <experiment name="deplacement-energie" repetitions="1" runMetricsEveryStep="true">
    <setup>random-seed 1711 setup
ask turtles [set energie 10000]</setup>
    <go>let avant count turtles
ask turtles [
  let x-avant xcor let y-avant ycor let e-avant energie
  deplacer-et-consommer
  let cout e-avant - energie
  let trajet distancexy x-avant y-avant
  if cout &lt; 0 or cout &gt; vitesse-max * energie-par-case [error "borne energie"]
  if abs (cout - trajet * energie-par-case) &gt; 0.0000001 [error "distance et cout"]
  if trajet &gt; vitesse-max + 0.0000001 [error "vitesse"]
]
tick
if count turtles &gt; avant [error "population croissante"]</go>
    <timeLimit steps="100" />
    <metric>count turtles</metric>
    <metric>ticks</metric>
    <metric>sum [energie] of turtles</metric>
    <metric>length remove-duplicates [heading] of turtles</metric>
  </experiment>
  <experiment name="mort" repetitions="1" runMetricsEveryStep="true">
    <setup>setup ask turtles [set energie 0]</setup>
    <go>go
if any? turtles [error "mort"]
if ticks != 1 [error "tick mort"]</go>
    <timeLimit steps="1" />
    <metric>count turtles</metric>
    <metric>ticks</metric>
  </experiment>
  <experiment name="extinction" repetitions="1" runMetricsEveryStep="true">
    <setup>random-seed 1711 setup</setup>
    <go>let avant count turtles
go
if count turtles &gt; avant [error "population croissante"]</go>
    <timeLimit steps="1000" />
    <exitCondition>not any? turtles</exitCondition>
    <metric>count turtles</metric>
    <metric>ticks</metric>
  </experiment>
  <experiment name="monde-vide" repetitions="1" runMetricsEveryStep="true">
    <setup>setup clear-turtles</setup>
    <go>go
if ticks != 0 [error "temps apres extinction"]</go>
    <timeLimit steps="1" />
    <metric>count turtles</metric>
    <metric>ticks</metric>
  </experiment>
  <experiment name="dernier-pas-et-bord" repetitions="1" runMetricsEveryStep="true">
    <setup>setup clear-turtles
create-turtles 1 [setxy max-pxcor 0 set heading 90 set energie 10 forward 2
if abs (xcor - (min-pxcor + 1)) &gt; 0.0000001 [error "raccord bord"]]
ask turtles [set energie 0.5]
random-seed 1711</setup>
    <go>go</go>
    <timeLimit steps="100" />
    <exitCondition>not any? turtles</exitCondition>
    <metric>count turtles</metric>
    <metric>ticks</metric>
  </experiment>
</experiments>
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

