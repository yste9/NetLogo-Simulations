;; Demonstration souris - cours pages 39-40.
to setup
  clear-all
  ask patches [set pcolor black]
  reset-ticks
end

to go-ihm
  if mouse-inside? and mouse-down? [ask patch mouse-xcor mouse-ycor [set pcolor white]]
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
0
0
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
GO-IHM
go-ihm
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
15
115
255
160
Souris dans la vue ?
mouse-inside?
2
1
11

MONITOR
15
170
255
215
X souris
mouse-xcor
2
1
11

MONITOR
15
225
255
270
Y souris
mouse-ycor
2
1
11
@#$#@#$#@
## Test_EvtSouris
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

