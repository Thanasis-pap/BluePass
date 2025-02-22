import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SecureKeyStorage {
  final _storage = const FlutterSecureStorage();
  static const _key = 'aes_key';

  Future<void> storeKey(String aesKey) async {
    await _storage.write(key: _key, value: aesKey);
  }

  Future<String?> retrieveKey() async {
    return await _storage.read(key: _key);
  }

  Future<void> deleteKey() async {
    await _storage.delete(key: _key);
  }

  String generateAESKey() {
    final key = encrypt.Key.fromSecureRandom(32); // 256-bit key
    return key.base64;
  }
}
