class KeyEncrypter {
  static String encrypt(String plaintext, {int shift = 4}) {
    String ciphertext = '';
    for (int i = 0; i < plaintext.length; i++) {
      int charCode = plaintext.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) {
        ciphertext += String.fromCharCode((charCode - 65 + shift) % 26 + 65);
      } else if (charCode >= 97 && charCode <= 122) {
        ciphertext += String.fromCharCode((charCode - 97 + shift) % 26 + 97);
      } else {
        ciphertext += plaintext[i];
      }
    }

    return ciphertext;
  }

  static String decrypt(String ciphertext, {int shift = 4}) {
    return encrypt(ciphertext, shift: 26 - shift);
  }
}
