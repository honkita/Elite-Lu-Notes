
public class main {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		HomeBase home = HomeBase.getInstance();
		NormalRemoteBase r1 = new NormalRemoteBase("μ's", HomeBase.getInstance());
		//r1.printSpies();
		Spy honoka = new Spy("Honoka", r1);
		Spy umi = new Spy("Umi", r1);
		Spy kotori = new Spy("Kotori", r1);
		Spy b = new Spy("b", r1);
		b.kill();
		NormalRemoteBase r2 = new NormalRemoteBase("Aqours", HomeBase.getInstance());
		Spy chika = new Spy("Chika", r2);
		Spy you = new Spy("You", r2);
		Spy riko = new Spy("Riko", r2);
		
		
		kotori.printMessage();  //Should print out stating that Kotori received no message
		r1.sendMessage("helloXzZ", kotori);
		
		
		DecodeInterface p = new CaesarCipher();
		p = new AlternatingDecorator(p);
		p = new AlternatingDecorator(p);
		p = new CaesarDecorator(p);
		
		home.changeMethod(p);
		home.changeKey(6);
		
		r1.sendMessage("helloXzZ", kotori);
		kotori.printMessage(); //shows the message again
		
		p = new AlternatingCipher();
		home.changeMethod(p);
		home.changeKey(4);
		r1.sendMessage("helloXzZ", kotori);
		
		p = new AlternatingDecorator(p);
		p = new AlternatingDecorator(p);
		p = new CaesarDecorator(p);
		home.changeMethod(p);
			
		home.changeKey(2);
		
		
		r2.goDark();
		r2.goDark();
		home.printBases();
		
		p = new AlternatingCipher();
		home.changeMethod(p);
		home.changeKey(4);
		
		honoka.sendMessage("Faito da yo!", chika);		
		you.sendMessage("Yousoro", riko);
		
		r2.sendMessage("uwu", honoka);
		r2.reconnect();
		r2.reconnect();
		r2.sendMessage("uwu", honoka);
		r2.reconnect();
	}

}
