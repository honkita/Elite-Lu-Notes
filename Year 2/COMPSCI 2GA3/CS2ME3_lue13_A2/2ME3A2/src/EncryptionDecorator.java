
public abstract class EncryptionDecorator implements DecodeInterface{
	
	private DecodeInterface b;
	
	EncryptionDecorator(DecodeInterface b){
		this.b = b;
	}
	
	@Override
	public String encrypt(String sentence, int key) {
		return b.encrypt(sentence, key);
	}
	
	@Override
	public String decrypt(String sentence, int key) {
		return b.decrypt(sentence, key);
	}
}
