import org.nlogo.headless.HeadlessWorkspace;
class Check {
 public static void main(String[] args) throws Exception {
  HeadlessWorkspace w = HeadlessWorkspace.newInstance();
  try {
   w.open(args[0]);
   w.command("random-seed 1711 setup repeat 100 [go]");
   System.out.println("Apres extinction : " + w.report("(list count turtles ticks)"));
   if (!w.report("count turtles = 0 and ticks = 23").equals(true)) throw new Exception("extinction");
   w.command("repeat 100 [go]");
   if (!w.report("count turtles = 0 and ticks = 23").equals(true)) throw new Exception("temps apres extinction");
   w.command("setup clear-turtles repeat 10 [go]");
   if (!w.report("ticks = 0").equals(true)) throw new Exception("monde vide");
   System.out.println("PASS : 100 appels apres extinction sans changement ; monde vide sans tick.");
  }
  finally {w.dispose();}
 }
}
