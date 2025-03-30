import java.util.ArrayList;

public class HomeBase extends MessageSender {

	private final String NAME = "Home Base";
	private static HomeBase homeBase;
	private ArrayList<RemoteBaseInterface> connectBases = new ArrayList<RemoteBaseInterface>();
	private int key = 0;
	private DecodeInterface c;

	private HomeBase() {
		// set default decode method to Caesar cipher
		
		System.out.println("Home Base created");
		c = new CaesarCipher(); //initialize as a Caesar cipher
	}

	protected static HomeBase getInstance() {
		if (homeBase == null)
			homeBase = new HomeBase();
		return homeBase;
	}

	protected void baseConnect(RemoteBaseInterface r) {
		if (!connectBases.contains(r)) {
			connectBases.add(r);
			update(key, c);
			System.out.println("Remote base " + r.getName() + " is now connected to the home base");
		} else {
			System.out.println("Remote base " + r.getName() + " has already been connected to the home base");
		}
	}

	protected void baseRemove(RemoteBaseInterface r) {
		if (connectBases.contains(r)) {
			connectBases.remove(r);
			System.out.println("Remote base " + r.getName() + " has been excommunicated from home base");
		} else {
			System.out.println("Remote base " + r.getName() + " has already excommunicated from home base");
		}
	}

	protected void changeKey(int value) {
		key = value;
		System.out.println("The key has been changed to " + value);
		update(this.key, c);
	}

	protected void changeMethod(DecodeInterface method) {
		c = method;
		update(this.key, this.c);
		
	}
	
	protected void printBases() {
		if(!connectBases.isEmpty()) {
			System.out.println("--------------------------------------------------------------------------");
			System.out.println("Remote bases connected to the home base include:");
			for(RemoteBaseInterface s : connectBases) {
				System.out.println("\t" + s.getName());
			}
			System.out.println("--------------------------------------------------------------------------");
		} else {
			System.out.println("There are no remote bases connected to the home base");
		}
		
	}

	@Override
	public String getName() {
		return NAME;
	}

	@Override
	public void update(int key, DecodeInterface c) {
		System.out.println("Updating the following:");
		super.update(key, c);
		for (RemoteBaseInterface b : connectBases) {
			System.out.println("\t" + b.getName());
			b.update(key, c);
		}
		
	}

}
