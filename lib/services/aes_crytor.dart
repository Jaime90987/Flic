import 'package:encrypt/encrypt.dart';

class AESCryptor {
  static final key = Key.fromUtf8('nhcgaujrprjajpwr42vv4rrtuflrbjcj');
  static final iv = IV.fromLength(16);
  static final encrypter = Encrypter(AES(key));

  static String encrypt(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedInput) {
    final decrypted = encrypter.decrypt64(encryptedInput, iv: iv);
    return decrypted;
  }
}
