import org.nlogo.headless.HeadlessWorkspace;

// Pilote le moteur NetLogo officiel ; aucune simulation n'est recodee en Java.
class CheckV1 {
  static void check(HeadlessWorkspace w, String expression, String message) throws Exception {
    if (!Boolean.TRUE.equals(w.report(expression))) throw new Exception(message);
  }
  public static void main(String[] args) throws Exception {
    HeadlessWorkspace v0 = HeadlessWorkspace.newInstance();
    HeadlessWorkspace v1 = HeadlessWorkspace.newInstance();
    try {
      v0.open(args[0]); v1.open(args[1]);
      check(v1, "nb-tortues = 30 and x-nid = 0 and y-nid = 0 and vitesse-max = 2 and energie-max = 20 and energie-par-case = 1", "valeurs des sliders");
      v0.command("random-seed 1711 setup");
      v1.command("random-seed 1711 setup");
      String trace = "(list ticks sort [ (list who xcor ycor heading energie) ] of turtles)";
      for (int i=0; i<101; i++) {
        if (!v0.report(trace).equals(v1.report(trace))) throw new Exception("difference v0/v1 au tour " + i);
        v0.command("go"); v1.command("go");
      }
      check(v1,"count turtles = 0", "extinction");
      Object tickFinal = v1.report("ticks");
      v1.command("repeat 100 [go]");
      if (!tickFinal.equals(v1.report("ticks"))) throw new Exception("temps apres extinction");
      System.out.println("PASS : valeurs initiales des six sliders ; traces v0/v1 identiques sur 101 etats ; extinction tick " + tickFinal + " ; 100 appels supplementaires sans progression.");

      v1.command("set nb-tortues 12 set x-nid -25 set y-nid 25 set energie-max 1 set vitesse-max 0 set energie-par-case 0.1 setup");
      check(v1,"count turtles = 12 and all? turtles [xcor = -25 and ycor = 25 and energie = 1]", "reglages personnalises");
      check(v1,"nb-tortues = 12 and x-nid = -25 and y-nid = 25 and energie-max = 1 and vitesse-max = 0 and energie-par-case = 0.1", "setup ecrase sliders");
      v1.command("repeat 25 [go]");
      check(v1,"ticks = 25 and count turtles = 12 and all? turtles [xcor = -25 and ycor = 25 and energie = 1]", "vitesse nulle");
      System.out.println("PASS : reglages conserves par setup ; nid aux limites ; energie-max 1 ; vitesse nulle pendant 25 tours.");

      v1.command("set vitesse-max 10 set energie-par-case 5 ask turtles [set energie 10000]");
      for (int i=0; i<100; i++) {
        v1.command("ask turtles [ let x0 xcor let y0 ycor let e0 energie deplacer-et-consommer let d distancexy x0 y0 if d > vitesse-max + 1.0E-7 or energie > e0 or abs (e0 - energie - d * energie-par-case) > 1.0E-7 [error \"cout ou distance\"] ] tick");
      }
      check(v1,"count turtles = 12", "survivants test cout");
      System.out.println("PASS : vitesse 10 et cout 5 pris en compte sans setup ; 1200 mises a jour avec cout proportionnel.");

      v1.command("set nb-tortues 200 set x-nid 25 set y-nid -25 set energie-max 100 set vitesse-max 2 set energie-par-case 0.1 setup");
      check(v1,"count turtles = 200 and all? turtles [xcor = 25 and ycor = -25 and energie >= 1 and energie <= 100]", "bornes hautes");
      v1.command("set nb-tortues 0 setup repeat 10 [go]");
      check(v1,"count turtles = 0 and ticks = 0", "effectif nul");
      System.out.println("PASS : effectif 200 ; nid oppose ; energie-max 100 ; effectif nul sans progression des ticks.");
      System.out.println("SUCCES : tous les controles NetLogo v1 sont passes.");
    } finally { v0.dispose(); v1.dispose(); }
  }
}
