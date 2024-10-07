import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:passwordmanager/helpers/aes_helper.dart';  // Assuming you have this AESHelper class for encryption

class UserDatabaseHelper {
  static final UserDatabaseHelper _instance = UserDatabaseHelper._internal();
  static Database? _database;
  final AESHelper _aesHelper = AESHelper();  // For encryption and decryption

  factory UserDatabaseHelper() => _instance;

  UserDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS users');
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  // Register user with encrypted email and password
  Future<int> registerUser(String name, String email, String password) async {
    final db = await database;

    // Encrypt both the email and password before storing them in the database
    String encryptedEmail = await _aesHelper.encryptText(email);
    String encryptedPassword = await _aesHelper.encryptText(password);

    return await db.insert('users', {
      'name': name,
      'email': encryptedEmail,  // Store encrypted email
      'password': encryptedPassword,  // Store encrypted password
    });
  }

  // Login user by checking the encrypted email and password
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;

    // Encrypt the email to match the one stored in the database
    String encryptedEmail = await _aesHelper.encryptText(email);

    // Fetch the user by encrypted email
    final result = await db.query('users', where: 'email = ?', whereArgs: [encryptedEmail]);

    if (result.isNotEmpty) {
      // Get the encrypted password from the database
      String encryptedPassword = result.first['password'] as String;

      // Decrypt the stored password
      String decryptedPassword = await _aesHelper.decryptText(encryptedPassword);

      // Check if the provided password matches the decrypted password
      if (password == decryptedPassword) {
        return result.first;  // Login successful
      }
    }

    return null;  // Login failed
  }

  Future<bool> loginBiometric(String email, String password) async {
    final db = await database;

    // Encrypt the email to match the one stored in the database
    String encryptedEmail = await _aesHelper.encryptText(email);

    // Fetch the user by encrypted email
    final result = await db.query('users', where: 'email = ?', whereArgs: [encryptedEmail]);

    if (result.isNotEmpty) {
      return true;
    }

    return false;  // Login failed
  }
}
