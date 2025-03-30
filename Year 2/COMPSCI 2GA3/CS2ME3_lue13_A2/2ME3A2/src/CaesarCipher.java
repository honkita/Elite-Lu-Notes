
public class CaesarCipher implements DecodeInterface{

	public String encrypt(String sentence, int key) {
		System.out.print("\tEncrypting with caesar cipher: ");
		String s = "";
		for (int i = 0; i < sentence.length(); i++) {

			char a = sentence.charAt(i);
			
			int temp = (int) a;
			if ((temp >= 65 && temp <= 90) || (temp >= 97 && temp <= 122)) {
				for (int p = 0; p < key; p++) {
					temp++;
					if (temp > 122) {
						temp = 97;
					} else if (temp > 90 && temp < 97) {
						temp = 65;
					}
				}
			}
			s = s + (char) temp;

		}
		System.out.println(s);
		return s;
	}

	public String decrypt(String sentence, int key) {		
		String s = "";
		for (int i = 0; i < sentence.length(); i++) {

			char a = sentence.charAt(i);
			int temp = (int) a;
			
			if ((temp >= 65 && temp <= 90) || (temp >= 97 && temp <= 122)) {
				for (int p = 0; p < key; p++) {
					temp--;
					if (temp < 65) {
						temp = 90;
					} else if (temp > 90 && temp < 97) {
						temp = 122;
					}
				}
			}
			s = s + (char) temp;

		}
		
		System.out.print("\tDecrypting with caesar cipher: ");
		System.out.println(s);
		return s;
	}

}
