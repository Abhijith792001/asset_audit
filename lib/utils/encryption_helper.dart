import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  // 32-character AES key (256 bits)
  static final _key = encrypt.Key.fromUtf8('amritaXsecureXflutterXkey12345678');
  static final _iv = encrypt.IV.fromLength(16); // AES requires 16-byte IV

  static String encryptText(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
