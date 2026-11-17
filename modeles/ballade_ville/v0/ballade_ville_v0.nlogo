;; Ballade en Ville - cours pages 43-44.
globals [filename ok?]

to setup
  clear-all
  ask patches [set pcolor white]
  set filename "" set ok? false
  reset-ticks
end

to initialiser-personnes
  if not ok? [user-message "Charger une ville avant de creer les promeneurs." stop]
  let rues patches with [pcolor = white]
  if not any? rues [user-message "Aucun espace ouvert dans cette ville." stop]
  clear-turtles
  create-turtles nombre-personnes [move-to one-of rues set color blue set size 0.8]
  reset-ticks
end

to go
  if not ok? or not any? turtles [stop]
  ask turtles [
    ;; Pas cardinal de patch en patch : pas de traversée ni de coin coupe.
    let sorties neighbors4 with [pcolor = white]
    if any? sorties [let destination one-of sorties face destination move-to destination]
  ]
  tick
end

to ouvrir-ville
  let choix user-file
  if choix = false [stop] ;; annuler conserve la ville courante
  carefully [charger-ville choix] [user-message error-message]
end

to charger-ville [chemin]
  ;; Validation complete avant toute modification du monde.
  let coordonnees []
  carefully [
    file-open chemin
    while [not file-at-end?] [
      let colonne file-read
      if file-at-end? [error "Paire de coordonnees incomplete."]
      let ligne file-read
      if not is-number? colonne or not is-number? ligne [error "Coordonnees numeriques attendues."]
      if colonne != floor colonne or ligne != floor ligne [error "Coordonnees entieres attendues."]
      if colonne < min-pxcor or colonne > max-pxcor or ligne < min-pycor or ligne > max-pycor [error "Coordonnees hors du monde."]
      set coordonnees lput (list colonne ligne) coordonnees
    ]
    file-close
  ] [
    let message-erreur error-message
    carefully [file-close] []
    error message-erreur
  ]
  clear-turtles
  ask patches [set pcolor white]
  foreach coordonnees [xy -> ask patch (item 0 xy) (item 1 xy) [set pcolor black]]
  set filename chemin
  set ok? true
  reset-ticks
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
EFFACER / INITIALISE
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
OUVRIR UNE VILLE
ouvrir-ville
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
105
255
140
CREER LES PROMENEURS
initialiser-personnes
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
150
255
185
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
200
255
240
nombre-personnes
nombre-personnes
0
200
50
1
1
NIL
HORIZONTAL

MONITOR
15
255
255
300
Promeneurs
count turtles
2
1
11

MONITOR
15
310
255
355
Ville chargee ?
ok?
2
1
11

BUTTON
15
370
255
405
EXEMPLE FOURNI
charger-ville "ville_exemple.txt"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1
@#$#@#$#@
## ballade_ville_v0
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

