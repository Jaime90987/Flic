import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_flic/services/aes_crytor.dart';

void main() {
  group('AESCryptor', () {
    const email = 'jonhdoe@gmail.com';
    const encryptedText = 'yzwlkWpjQke7pPKvmU7DaL29FgeD1yXgn+MqfnFXVGA=';

    test('encrypt should encrypt plain text', () {
      final encrypted = AESCryptor.encrypt(email);
      expect(encrypted, equals(encryptedText));
    });

    test('decrypt should decrypt encrypted text', () {
      final decrypted = AESCryptor.decrypt(encryptedText);
      expect(decrypted, equals(email));
    });
  });
}
