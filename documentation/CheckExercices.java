import org.nlogo.headless.HeadlessWorkspace;
import java.nio.file.*;

// Toutes les dynamiques et les lectures/ecritures sont executees dans NetLogo.
class CheckExercices {
  static void check(HeadlessWorkspace w, String expr, String label) throws Exception {
    if (!Boolean.TRUE.equals(w.report(expr))) throw new Exception(label);
  }
  static String quote(Path path) {return "\""+path.toAbsolutePath().toString().replace('\\','/')+"\"";}
  static void cmd(HeadlessWorkspace w, String text) throws Exception {w.command(text);}
  public static void main(String[] args) throws Exception {
    Path root=Path.of(args[0]).toAbsolutePath();
    Path fixtures=Files.createTempDirectory(root.resolve("documentation"),"validation-villes-");
    String[][] models={{"paisibles_moutons","paisibles_moutons_v0"},{"predators","predators_v0"},{"creation_ville","creation_ville_v0"},{"ballade_ville","ballade_ville_v0"},{"test_souris","Test_EvtSouris"}};
    for(String[] model:models) {
      HeadlessWorkspace w=HeadlessWorkspace.newInstance();
      try {
        Path folder=root.resolve("modeles/"+model[0]+"/v0");
        w.open(folder.resolve(model[1]+".nlogo").toString());
        cmd(w,"random-seed 1711 setup");
        System.out.println("CHARGE ET COMPILE : "+model[1]);
        if(model[0].equals("paisibles_moutons") || model[0].equals("predators")) {
          check(w,"count moutons = nb-moutons-init and all? moutons [sante = 100 and age = 0] and all? patches [herbe >= 50 and herbe <= 100]", "initialisation animaux");
          cmd(w,"set proba-reproduction 0 set proba-mort-naturelle 0 ask patches [set herbe 8] ask moutons [setxy 0 0 set sante 50] set conso-herbe 8 nourrir-moutons");
          check(w,"[herbe] of patch 0 0 = 0 and count moutons with [sante = 51] = 1", "partage ressource et egalite nourriture");
          cmd(w,"ask patches [set herbe 99.9] set croissance-herbe 10 croitre-herbe");
          check(w,"all? patches [herbe = 100]", "plafond herbe");
          cmd(w,"clear-turtles create-moutons 1 [set sante 100 set age 0] set proba-reproduction 1 vie-moutons");
          check(w,"count moutons = 2 and count moutons with [age = 0 and sante = 50] = 1 and count moutons with [age = 1 and sante = 75] = 1", "reproduction et nouveau ne");
          cmd(w,"ask moutons [set sante 20] vie-moutons");
          check(w,"count moutons = 2", "reproduction restreinte sante");
          cmd(w,"set proba-reproduction 0 ask moutons [set sante 0] vie-moutons");
          check(w,"not any? moutons", "mort faim");
          cmd(w,"create-moutons 5 [set sante 100] set proba-mort-naturelle 1 vie-moutons");
          check(w,"not any? moutons", "mort naturelle certaine");
          if(model[0].equals("predators")) {
            cmd(w,"clear-turtles set seuil-chasse 30 set vitesse-predator 2 set rayon-vision-predator 4 create-moutons 1 [setxy 2 0 set sante 100] create-predators 1 [setxy 0 0 set sante 20] chasser-predators");
            check(w,"count moutons = 0 and count predators = 1 and all? predators [xcor = 2 and ycor = 0 and sante = 69]", "chasse et repas");
            cmd(w,"set proba-repro-predator 0 set proba-mort-predator 0 repeat 100 [chasser-predators vie-predators]");
            check(w,"not any? predators", "predateurs sans nourriture");
            cmd(w,"create-predators 1 [set sante 100 set age 0] set proba-repro-predator 1 vie-predators");
            check(w,"count predators = 2 and count predators with [sante = 50 and age = 0] = 1", "reproduction predateur");
            cmd(w,"set proba-repro-predator 0 set proba-mort-predator 1 vie-predators");
            check(w,"not any? predators", "mort naturelle predateur");
          }
          System.out.println("PASS : initialisation, nourriture partagee, plafond herbe, naissances, faim et mortalite"+(model[0].equals("predators") ? ", chasse et cycle predateurs." : "."));
          for(int seed:new int[]{1711,42,7}) {
            cmd(w,"set nb-moutons-init 75 set conso-herbe 8 set croissance-herbe 1 set proba-reproduction 0.001 set proba-mort-naturelle 0.0001"+(model[0].equals("predators") ? " set proba-repro-predator 0.0002 set proba-mort-predator 0.0001" : "")+" random-seed "+seed+" setup");
            for(int i=0;i<100;i++) {
              cmd(w,"go");
              check(w,"all? patches [herbe >= 0 and herbe <= 100]", "bornes herbe");
              check(w,"all? turtles [sante > 0 and sante <= 100 and age >= 0]", "sante survivants");
            }
            System.out.println("PASS : graine "+seed+", tick="+w.report("ticks")+", moutons="+w.report("count moutons")+", herbe moyenne="+w.report("mean [herbe] of patches")+(model[0].equals("predators") ? ", predateurs="+w.report("count predators") : ""));
          }
        } else if(model[0].equals("creation_ville")) {
          check(w,"[patch-at 1 0] of patch max-pxcor 0 = nobody", "topologie bornee");
          cmd(w,"peindre-bloc 0 0 1 peindre-bloc 2 2 2");
          check(w,"count patches with [pcolor = black] = 5", "blocs 1 et 2");
          cmd(w,"peindre-bloc 25 25 2");
          check(w,"count patches with [pcolor = black] = 6 and [pcolor] of patch -25 -25 = white", "bloc limite sans raccord");
          Path saved=fixtures.resolve("ville_sauvee.txt");
          cmd(w,"sauvegarder-ville "+quote(saved));
          cmd(w,"carefully [sauvegarder-ville "+quote(saved)+" error \"pas de refus\"] [if error-message = \"pas de refus\" [error error-message]]");
          check(w,"count patches with [pcolor = black] = 6", "sauvegarde stable");
          cmd(w,"setup charger-ville "+quote(saved));
          check(w,"count patches with [pcolor = black] = 6 and ok?", "aller retour fichier");
          String[] bad={"0", "999 0", "\"texte\" 0", "0.2 0"};
          for(int i=0;i<bad.length;i++) {
            Path malformed=fixtures.resolve("invalide"+i+".txt");Files.writeString(malformed,bad[i]);
            Object before=w.report("sort patches with [pcolor = black]");
            boolean rejected=false;
            try {cmd(w,"charger-ville "+quote(malformed));}catch(Exception ex){rejected=true;}
            if(!rejected || !before.equals(w.report("sort patches with [pcolor = black]"))) throw new Exception("import invalide non transactionnel");
          }
          Path empty=fixtures.resolve("ville_vide.txt");Files.writeString(empty,"");cmd(w,"charger-ville "+quote(empty));
          check(w,"ok? and count patches with [pcolor = black] = 0", "ville vide valide");
          cmd(w,"charger-ville "+quote(saved));
          System.out.println("PASS : blocs 1x1/2x2, limites, sauvegarde sans ecrasement, relecture, quatre fichiers invalides sans alteration et fichier vide.");
        } else if(model[0].equals("ballade_ville")) {
          cmd(w,"charger-ville "+quote(fixtures.resolve("ville_sauvee.txt"))+" set nombre-personnes 50 initialiser-personnes repeat 200 [go]");
          check(w,"count turtles = 50 and ticks = 200 and all? turtles [[pcolor] of patch-here = white]", "promeneurs rues");
          cmd(w,"ask patches [set pcolor black] ask patch 0 0 [set pcolor white] ask turtles [move-to patch 0 0] repeat 10 [go]");
          check(w,"all? turtles [xcor = 0 and ycor = 0]", "enfermement");
          cmd(w,"charger-ville "+quote(folder.resolve("ville_exemple.txt"))+" initialiser-personnes repeat 20 [go]");
          System.out.println("PASS : ville sauvee par l'editeur chargee, 50 promeneurs sur rues pendant 200 tours, enfermement sans passage de mur, exemple fourni.");
        } else {
          cmd(w,"go-ihm");
          check(w,"count patches with [pcolor = white] = 0 and ticks = 0", "souris sans clic");
          System.out.println("PASS : GO-IHM sans clic ne modifie pas le monde ; interaction physique a verifier manuellement.");
        }
        cmd(w,"export-view "+quote(root.resolve("documentation/apercu-"+model[0]+".png")));
      } finally {w.dispose();}
    }
    System.out.println("SUCCES : cinq modeles valides. Fichiers de test : documentation/"+fixtures.getFileName());
  }
}
