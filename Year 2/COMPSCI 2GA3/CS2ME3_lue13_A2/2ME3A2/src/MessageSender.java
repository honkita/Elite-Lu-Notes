
public abstract class MessageSender implements EntityObject{
	private int key = 0;
	private DecodeInterface c;
	private String message = "";

	public void sendMessage(String message, MessageSender receiver) {
		System.out.println("--------------------------------------------------------------------------");
		System.out.println("Sender: " + getName());
		String encoded = c.encrypt(message, key);
		System.out.println("Encoded Message: " + encoded);
		System.out.println("Receiver: " + receiver.getName());
		receiver.receiveMessage(encoded);
		System.out.println("--------------------------------------------------------------------------");
		

	}

	public void receiveMessage(String message) {
		String decoded = c.decrypt(message, key);
		storeMessage(decoded);
		System.out.println("Decoded Message: " + decoded);
		

	}
	
	private void storeMessage(String message) {
		this.message = message;
	}
	
	public void printMessage() {
		if(message.equals("")) {
			System.out.println(getName() + " has not receieved a message yet!");
		} else {
			System.out.println("Last message that " + getName() + " received: " + message);
		}
		
	}
	
	public void update(int key, DecodeInterface c) {
		this.key = key;
		this.c = c;
	}
}
