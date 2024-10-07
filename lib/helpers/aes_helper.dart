import 'package:encrypt/encrypt.dart' as encrypt;

import '../global_dirs.dart';

class AESHelper {
  final SecureKeyStorage _keyStorage = SecureKeyStorage();
  Future<String?> get _key async {
    String? keyBase64 = await _keyStorage.retrieveKey();
    return keyBase64;
  }

  Future<String> encryptText(String text) async {
    String? keyBase64 = await _key;
    if (keyBase64 == null) {
      throw Exception('AES key is not available');
    }
    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  Future<String> decryptText(String encryptedText) async {
    String? keyBase64 = await _key;
    if (keyBase64 == null) {
      throw Exception('AES key is not available');
    }
    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}
