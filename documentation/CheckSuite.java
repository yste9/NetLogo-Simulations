import org.nlogo.headless.HeadlessWorkspace;

// Tests executes par le moteur officiel : Java ne calcule aucune dynamique.
class CheckSuite {
  static void check(HeadlessWorkspace w, String expr, String label) throws Exception {
    if (!Boolean.TRUE.equals(w.report(expr))) throw new Exception(label + " : " + w.report(expr));
  }
  static void cmd(HeadlessWorkspace w, String code) throws Exception { w.command(code); }
  static void defaults(HeadlessWorkspace w, int v) throws Exception {
    cmd(w,"set nb-tortues 20 set x-nid 0 set y-nid 0 set vitesse-max 2 set energie-max 50 set energie-par-case 1"
      + (v>=3 ? " set energie-seuil-retour 30 set angle-deplacement 100" : "")
      + (v==4 ? " set nb-obstacles 100" : ""));
  }
  public static void main(String[] args) throws Exception {
    int premiereVersion = args.length > 1 ? Integer.parseInt(args[1]) : 2;
    for (int version=premiereVersion; version<=4; version++) {
      HeadlessWorkspace w = HeadlessWorkspace.newInstance();
      try {
        w.open(args[0]+"/v"+version+"/vie_de_tortue_v"+version+".nlogo");
        System.out.println("V"+version+" chargee et compilee.");
        defaults(w,version);
        cmd(w,"random-seed 1711 setup");
        check(w,"count turtles = 20 and sum [morts] of patches = 0 and all? turtles [energie > 0 and energie = energie-init and xcor = 0 and ycor = 0]", "initialisation");
        check(w,"all? turtles [color = [0 210 0]]", "couleur au plein");
        cmd(w,"ask turtles [set energie energie-init / 2 actualiser-couleur]");
        check(w,"all? turtles [color = [128 105 0]]", "couleur demi reserve");
        cmd(w,"ask turtles [set energie 0] go");
        check(w,"count turtles = 0 and sum [morts] of patches = 20 and [morts] of patch 0 0 = 20 and [plabel] of patch 0 0 = 20", "comptage morts");
        Object time=w.report("ticks"); cmd(w,"repeat 10 [go]");
        if (!time.equals(w.report("ticks"))) throw new Exception("temps monde vide");
        cmd(w,"setup");
        check(w,"sum [morts] of patches = 0 and all? patches [plabel = \"\"]", "reset morts");
        System.out.println("PASS : initialisation, couleurs plein/demi-reserve, 20 deces au nid, etiquettes, reset et arret monde vide.");

        if(version>=3) {
          if(version==4) cmd(w,"set nb-obstacles 0");
          cmd(w,"set nb-tortues 1 set energie-max 20 set energie-seuil-retour 50 set vitesse-max 2 setup ask turtles [setxy 3 0 set energie-init 20 set energie 3 set retour? false] go");
          check(w,"all? turtles [abs (xcor - 1) < 1.0E-8 and abs ycor < 1.0E-8 and energie = 1 and retour?]", "retour premier tour");
          cmd(w,"go");
          check(w,"count turtles = 1 and all? turtles [xcor = 0 and ycor = 0 and energie = 20 and not retour?]", "plein a arrivee avec energie exacte");
          cmd(w,"ask turtles [setxy 3 0 set energie 1 set retour? true] go");
          check(w,"count turtles = 0 and sum [morts] of patches = 1", "retour impossible faute energie");
          cmd(w,"set energie-max 1 setup");
          check(w,"all? turtles [energie = 1 and energie-init = 1]", "energie maximale 1");
          cmd(w,"set energie-max 50 set energie-seuil-retour 0 set angle-deplacement 0 set vitesse-max 2 setup ask turtles [set heading 90 set energie-init 1000 set energie 1000] repeat 30 [go]");
          check(w,"count turtles = 1 and all? turtles [heading = 90 and abs ycor < 1.0E-8]", "angle nul");
          cmd(w,"set x-nid 5");
          check(w,"nid-x = 0", "nid fige");
          System.out.println("PASS : retour a vitesse maximale, plein individuel a energie exactement nulle, mort avant arrivee, energie-max 1, angle nul et nid fige.");
          cmd(w,"set angle-deplacement 100 ask turtles [setxy 3 0.25 set energie-init 1000 set energie 1000]");
          for(int i=0;i<100;i++) {
            cmd(w,"ask turtles [let cap-avant heading let x-avant xcor let y-avant ycor let e-avant energie deplacer-et-consommer if abs (subtract-headings heading cap-avant) > 100 [error \"angle hors borne\"] let trajet distancexy x-avant y-avant if trajet > vitesse-max + 1.0E-8 or abs (e-avant - energie - trajet * energie-par-case) > 1.0E-8 [error \"cout trajet\"]]");
          }
          System.out.println("PASS : 100 deplacements exploratoires, variation angulaire bornee et cout proportionnel.");
        }
        if(version==4) {
          defaults(w,version); cmd(w,"setup");
          check(w,"count patches with [obstacle?] = 100 and not [obstacle?] of patch 0 0 and all? turtles [not [obstacle?] of patch-here]", "generation obstacles");
          cmd(w,"set nb-tortues 1 set nb-obstacles 0 setup ask turtles [set heading 90] ask patch 1 0 [set obstacle? true]");
          check(w,"all? turtles [not trajet-libre? 4]", "obstacle intermediaire");
          cmd(w,"ask turtles [avancer-prudemment 4]");
          check(w,"all? turtles [not [obstacle?] of patch-here]", "evitement");
          cmd(w,"ask patches [set obstacle? false] ask turtles [setxy 25 0 set heading 90] ask patch -25 0 [set obstacle? true]");
          check(w,"all? turtles [not trajet-libre? 2]", "obstacle au raccord torique");
          cmd(w,"ask patches [set obstacle? false] ask turtles [setxy 0 0 set heading 45] ask patch 1 0 [set obstacle? true]");
          check(w,"all? turtles [not trajet-libre? 2]", "coin diagonal");
          cmd(w,"ask patches [set obstacle? false] ask turtles [setxy 0 0 set energie 20] ask patch 0 0 [ask neighbors [set obstacle? true]] ask turtles [avancer-prudemment 2]");
          check(w,"all? turtles [xcor = 0 and ycor = 0 and energie = 20]", "encerclement");
          cmd(w,"set nb-obstacles 2600 setup repeat 10 [go]");
          check(w,"count patches with [obstacle?] = 2600 and all? turtles [xcor = 0 and ycor = 0]", "monde sature");
          System.out.println("PASS : obstacles exacts, nid libre, obstacle intermediaire, raccord torique, coin diagonal, encerclement et 2600 obstacles.");
        }

        for (int seed : new int[]{1711,42,7}) {
          defaults(w,version); cmd(w,"random-seed "+seed+" setup");
          for(int tick=0;tick<100;tick++) {
            cmd(w,"let avant count turtles go if count turtles > avant [error \"population\"]");
            check(w,"count turtles + sum [morts] of patches = 20", "conservation effectif");
            check(w,"all? turtles [energie > 0 and energie <= energie-init + 1.0E-8]", "reserve survivants");
            check(w,"all? patches [morts = 0 or plabel = morts]", "etiquettes morts");
            if(version==4) check(w,"all? turtles [not [obstacle?] of patch-here]", "occupation obstacle");
          }
          System.out.println("PASS : 100 appels GO, graine "+seed+", conservation effectif, reserves et etiquettes ; survivants="+w.report("count turtles")+", ticks="+w.report("ticks"));
        }
      } finally {w.dispose();}
    }
    System.out.println("SUCCES : tous les controles v2, v3 et v4 sont passes.");
  }
}
