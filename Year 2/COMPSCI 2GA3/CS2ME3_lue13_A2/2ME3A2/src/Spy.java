
public class Spy extends MessageSender implements SpyInterface {
	private final String NAME;
	private boolean isDead = false;
	private RemoteBaseInterface base;

	/**
	 * Constructor of the class
	 * 
	 * @param NAME
	 */
	protected Spy(String name, RemoteBaseInterface base) {
		this.NAME = name;
		this.base = base;
		System.out.println("Spy " + this.NAME + " has joined the network");
		base.addSpy(this);

	}

	/**
	 * Kills the spy
	 */
	@Override
	public void kill() {
		isDead = true;
		System.out.println("Spy " + NAME + " has been killed");
		base.removeSpy(this);
		;
	}

	/**
	 * Returns if a spy is dead or not
	 * 
	 * @return boolean
	 */
	@Override
	public boolean died() {
		return isDead;
	}

	/**
	 * Gets the NAME of the spy
	 * 
	 * @return String
	 */
	@Override
	public String getName() {
		return NAME;
	}

	/**
	 * 
	 */
	@Override
	public void update(int key, DecodeInterface c) {
		super.update(key, c);
	}

	@Override
	public void sendMessage(String message, MessageSender receiver) {
		if (!isDead) {
			super.sendMessage(message, receiver);
		} else {
			System.out.println("Spy " + NAME + " is dead, so they can not send messages");
		}

	}

	@Override
	public void receiveMessage(String message) {
		if (!isDead) {
			super.receiveMessage(message);
		} else {
			System.out.println("Spy " + NAME + " is dead, so they can not receive messages");
		}

	}

}
