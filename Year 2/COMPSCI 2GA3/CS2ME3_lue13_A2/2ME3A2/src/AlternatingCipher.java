
public class AlternatingCipher implements DecodeInterface{

	@Override
	public String encrypt(String sentence, int key) {
			System.out.print("\tEncrypting with alternating cipher: ");
		String s = alternator(sentence, true, key);
		System.out.println(s);
		return s;
	}

	@Override
	public String decrypt(String sentence, int key) {
		String s = alternator(sentence, false, key);
		System.out.print("\tDecrypting with alternating cipher: ");
		System.out.println(s);
		return s;
	}

	private String alternator(String sentence, boolean upOrDown, int key) {
		String s = "";
		for (int i = 0; i < sentence.length(); i++) {

			char a = sentence.charAt(i);

			int temp = (int) a;
			if ((temp >= 65 && temp <= 90) || (temp >= 97 && temp <= 122)) {
				int increment = 0;
				if (upOrDown) {
					increment = 1;
				} else {
					increment = -1;
				}

				for (int p = 0; p < key; p++) {
					temp = temp + increment;
					
					if (temp < 65) {
						temp = 90;
					} else if (temp > 122) {
						temp = 97;
					} else if (temp > 90 && temp < 97 && upOrDown) {
						temp = 65;
					} else if (temp > 90 && temp < 97 && !upOrDown) {
						temp = 122;
					}

				}
				upOrDown = !upOrDown;
			}
			s = s + (char) temp;

		}

		return s;
	}

}
