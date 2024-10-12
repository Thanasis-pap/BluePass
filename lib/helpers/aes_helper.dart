import 'package:encrypt/encrypt.dart' as encrypt;

import '../global_dirs.dart';

class AESHelper {
  final SecureKeyStorage _keyStorage = SecureKeyStorage();
  Future<String?> get _key async {
    String? keyBase64 = await _keyStorage.retrieveKey();
    return keyBase64;
  }

  Future<String> encryptText(String text,[String? keyBase64]) async {
    if (keyBase64 == null) {
      keyBase64 = (await _key)!;
      //throw Exception('AES key is not available');
    }
    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromSecureRandom(16);
    print(key.base64);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return '${iv.base64} ${encrypted.base64}';
  }

  Future<String> decryptText(String encryptedText) async {
    String? keyBase64 = await _key;
    if (keyBase64 == null) {
      throw Exception('AES key is not available');
    }
    String ivText = encryptedText.split(' ')[0];
    String text = encryptedText.split(' ')[1];
    //print(ivText);
    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromBase64(ivText);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(text, iv: iv);
    print(decrypted);
    return decrypted;
  }
}
