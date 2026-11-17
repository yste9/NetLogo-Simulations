;; Creation Ville - cours pages 45-46.
globals [filename ok?]

to setup
  clear-all
  ask patches [set pcolor white]
  set filename "" set ok? true
  reset-ticks
end

to dessiner
  if mouse-inside? and mouse-down? [
    peindre-bloc (round mouse-xcor) (round mouse-ycor) taille-bloc
  ]
end

to peindre-bloc [colonne ligne taille]
  ;; Le bloc 2x2 s'etend vers la droite et vers le haut, comme page 46.
  foreach (range taille) [i -> foreach (range taille) [j ->
    let cible-x colonne + i
    let cible-y ligne + j
    if cible-x >= min-pxcor and cible-x <= max-pxcor and cible-y >= min-pycor and cible-y <= max-pycor [
      ask patch cible-x cible-y [set pcolor black]
    ]
  ]]
end

to sauver-ville
  let choix user-new-file
  if choix = false [stop]
  ;; Evite l'ajout silencieux a un fichier existant : aucune suppression automatique.
  carefully [sauvegarder-ville choix] [user-message error-message]
end

to sauvegarder-ville [chemin]
  if file-exists? chemin [error "Le fichier existe deja : choisir un nouveau nom."]
  carefully [
    file-open chemin
    foreach sort patches with [pcolor = black] [case-ville ->
      file-print (word [pxcor] of case-ville " " [pycor] of case-ville)
    ]
    file-close
    set filename chemin
  ] [
    let message-erreur error-message
    carefully [file-close] []
    error message-erreur
  ]
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
DESSINER (CONTINU)
dessiner
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
taille-bloc
taille-bloc
1
2
1
1
1
NIL
HORIZONTAL

BUTTON
15
165
255
200
SAUVER LA VILLE
sauver-ville
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
210
255
245
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

MONITOR
15
265
255
310
Cases baties
count patches with [pcolor = black]
2
1
11
@#$#@#$#@
## creation_ville_v0
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

