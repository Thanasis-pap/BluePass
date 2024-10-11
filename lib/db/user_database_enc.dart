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

  // Edit user details by ID or Email
  Future<int> editUser(int id, String? name, String? username, String? password) async {
    final db = await database;

    // Prepare a map with the new values for the fields
    Map<String, dynamic> updatedFields = {};

    if (name != null) updatedFields['name'] = name;
    if (username != null) {
      String encryptedEmail = await _aesHelper.encryptText(username);
      updatedFields['email'] = encryptedEmail;
    }
    if (password != null) {
      String encryptedPassword = await _aesHelper.encryptText(password);
      updatedFields['password'] = encryptedPassword;
    }

    // Update the user in the database
    return await db.update(
      'users',                 // Table name
      updatedFields,           // The fields to update
      where: 'id = ?',         // Which user to update
      whereArgs: [id],         // User's ID to update
    );
  }

  // Delete user by email or ID
  Future<int> deleteUser({int? id, String? username}) async {
    final db = await database;

    // Ensure at least one identifier (ID or email) is provided
    if (id == null && username == null) {
      throw ArgumentError('You must provide either an ID or an email to delete a user.');
    }

    // If email is provided, encrypt it
    String? encryptedEmail;
    if (username != null) {
      encryptedEmail = await _aesHelper.encryptText(username);
    }

    // Build the where clause based on the provided identifier
    String whereClause;
    List<dynamic> whereArgs;

    if (id != null) {
      whereClause = 'id = ?';
      whereArgs = [id];
    } else {
      whereClause = 'email = ?';
      whereArgs = [encryptedEmail];
    }

    // Perform the deletion
    return await db.delete(
      'users',             // Table name
      where: whereClause,   // Where clause to specify which user to delete
      whereArgs: whereArgs, // Arguments for where clause
    );
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

  Future<bool> loginBiometric(String email) async {
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

  Future<Map<String, dynamic>> loginName(String username) async {
    final db = await database;

    // Encrypt the email to match the one stored in the database
    String encryptedEmail = await _aesHelper.encryptText(username);

    // Fetch the user by encrypted email
    final result = await db.query('users', where: 'email = ?', whereArgs: [encryptedEmail]);

    return result[0];  // Login failed
  }
}
