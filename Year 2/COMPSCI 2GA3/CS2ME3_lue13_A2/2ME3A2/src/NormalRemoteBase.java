import java.util.ArrayList;

public class NormalRemoteBase extends MessageSender implements RemoteBaseInterface{

	private final String NAME;
	private ArrayList<SpyInterface> spyNetwork = new ArrayList<SpyInterface>();
	private HomeBase b;

	
	protected NormalRemoteBase(String name, HomeBase b) {
		this.NAME = name;
		this.b = b;
		System.out.println("Remote base " + this.NAME + " created");
		this.b.baseConnect(this);
		
	}

	@Override
	public void addSpy(SpyInterface s) {
		if(!spyNetwork.contains(s)) {
			spyNetwork.add(s);
			System.out.println("Spy " + s.getName() + " has been fitted with a pulse sensor "
					+ "and is now a part of remote base " + NAME);
		} else {
			System.out.println("The remote base has already been added");
		}
	}
	
	@Override
	public void removeSpy(SpyInterface s) {
		if(spyNetwork.contains(s) && s.died()) {
			spyNetwork.remove(s);
			System.out.println("Spy " + s.getName() + " has died and their pulse sensor sent a "
					+ "pulse to remote base " + NAME);
		} else {
			System.out.println("The spy has already been removed or is still alive");
		}
	}
	
	@Override
	public void printSpies() {
		if(!spyNetwork.isEmpty()) {
			System.out.println("--------------------------------------------------------------------------");
			System.out.println("Spies in remote base " + NAME + " include:");
			for(SpyInterface s : spyNetwork) {
				System.out.println("\t" + s.getName());
			}
			System.out.println("--------------------------------------------------------------------------");
		} else {
			System.out.println("There are no spies that come from remote base " + NAME);
		}
		
	}
	

	@Override
	public void update(int key, DecodeInterface c) {
		super.update(key, c);
		
		for(SpyInterface i : spyNetwork) {
			System.out.println("\t\t" + i.getName());
			i.update(key, c);
		}
	}

	@Override
	public String getName() {
		// TODO Auto-generated method stub
		return NAME;
	}

	@Override
	public void goDark() {
		b.baseRemove(this);
	}

	@Override
	public void reconnect() {
		b.baseConnect(this);
	}
	
	

}
