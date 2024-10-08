import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:passwordmanager/global_dirs.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  final AESHelper _aesHelper = AESHelper();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'secure_data.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Passwords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        webpage TEXT,
        username TEXT,
        password TEXT,
        notes TEXT,
        color TEXT,
        favorite INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        card_holder TEXT,
        card_number TEXT,
        expiration_date TEXT,
        cvv TEXT,
        notes TEXT,
        color TEXT,
        favorite INTEGER
      )
    ''');
  }

  // Password Table CRUD Operations

  Future<int> insertPassword(Map<String, dynamic> password) async {
    Database db = await database;
    Map<String, dynamic> encryptedPassword = {
      'name': password['name'],
      'webpage': password['webpage'],
      'username': await _aesHelper.encryptText(password['username']),
      'password': await _aesHelper.encryptText(password['password']),
      'notes': password['notes'],
      'color': password['color'],
      'favorite': password['favorite'] ? 1 : 0,
    };
    return await db.insert('Passwords', encryptedPassword);
  }

  Future<List<Map<String, dynamic>>> getPasswords() async {
    Database db = await database;
    List<Map<String, dynamic>> passwords = await db.query('Passwords');
    return Future.wait(passwords.map((password) async {
      return {
        'id': password['id'],
        'name': password['name'],
        'webpage': password['webpage'],
        'username': await _aesHelper.decryptText(password['username']),
        'password': await _aesHelper.decryptText(password['password']),
        'notes': password['notes'],
        'color': password['color'],
        'favorite': password['favorite'].isOdd ?? false,
      };
    }));
  }

  Future<Map<String, dynamic>?> findPasswordById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('Passwords', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      Map<String, dynamic> password = results.first;
      return {
        'id': password['id'],
        'name': password['name'],
        'webpage': password['webpage'],
        'username': await _aesHelper.decryptText(password['username']),
        'password': await _aesHelper.decryptText(password['password']),
        'notes': password['notes'],
        'color': password['color'],
        'favorite': password['favorite'].isOdd ?? false,
      };
    }
    return null;
  }

  // Card Table CRUD Operations

  Future<int> insertCard(Map<String, dynamic> card) async {
    Database db = await database;
    Map<String, dynamic> encryptedCard = {
      'name': card['name'],
      'card_holder': await _aesHelper.encryptText(card['card_holder']),
      'card_number': await _aesHelper.encryptText(card['card_number']),
      'expiration_date': await _aesHelper.encryptText(card['expiration_date']),
      'cvv': await _aesHelper.encryptText(card['cvv']),
      'notes': card['notes'],
      'color': card['color'],
      'favorite': card['favorite'] ? 1 : 0,
    };
    return await db.insert('Cards', encryptedCard);
  }

  Future<List<Map<String, dynamic>>> getCards() async {
    Database db = await database;
    List<Map<String, dynamic>> cards = await db.query('Cards');
    return Future.wait(cards.map((card) async {
      return {
        'id': card['id'],
        'name': card['name'],
        'card_holder': await _aesHelper.decryptText(card['card_holder']),
        'card_number': await _aesHelper.decryptText(card['card_number']),
        'expiration_date': await _aesHelper.decryptText(card['expiration_date']),
        'cvv': await _aesHelper.decryptText(card['cvv']),
        'notes': card['notes'],
        'color': card['color'],
        'favorite': card['favorite']==1,
      };
    }));
  }

  Future<List<Map<String, dynamic>>> getFavoriteCards() async {
    Database db = await database;
    List<Map<String, dynamic>> favoriteCards = await db.query(
        'Cards',
        where: 'favorite = ?',
        whereArgs: [1]
    );
    return Future.wait(favoriteCards.map((card) async {
      return {
        'id': card['id'],
        'name': card['name'],
        'card_holder': await _aesHelper.decryptText(card['card_holder']),
        'card_number': await _aesHelper.decryptText(card['card_number']),
        'expiration_date': await _aesHelper.decryptText(card['expiration_date']),
        'cvv': await _aesHelper.decryptText(card['cvv']),
        'notes': card['notes'],
        'color': card['color'],
        'favorite': card['favorite'] == 1, // Convert integer back to boolean
        'type': 'card', // Adding 'type' field
      };
    }));
  }

  Future<Map<String, dynamic>?> findCardById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('Cards', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      Map<String, dynamic> card = results.first;
      return {
        'id': card['id'],
        'name': card['name'],
        'card_holder': await _aesHelper.decryptText(card['card_holder']),
        'card_number': await _aesHelper.decryptText(card['card_number']),
        'expiration_date': await _aesHelper.decryptText(card['expiration_date']),
        'cvv': await _aesHelper.decryptText(card['cvv']),
        'notes': card['notes'],
        'color': card['color'],
        'favorite': card['favorite'].isOdd ?? false,
      };
    }
    return null;
  }

  Future<int> editCard(int id, Map<String, dynamic> card) async {
    Database db = await database;

    // Prepare the encrypted card fields using the same encryption helper
    Map<String, dynamic> encryptedCard = {
      'name': card['name'],
      'card_holder': await _aesHelper.encryptText(card['card_holder']),
      'card_number': await _aesHelper.encryptText(card['card_number']),
      'expiration_date': await _aesHelper.encryptText(card['expiration_date']),
      'cvv': await _aesHelper.encryptText(card['cvv']),
      'notes': card['notes'],
      'color': card['color'],
      'favorite': card['favorite'] ? 1 : 0,
    };

    // Update the existing card in the database based on its primary key (id)
    return await db.update(
      'Cards',                    // Table name
      encryptedCard,               // Data to update
      where: 'id = ?',             // Condition for which row to update
      whereArgs: [id],             // Arguments for the WHERE clause
    );
  }

  Future<int> editPassword(int id, Map<String, dynamic> password) async {
    Database db = await database;

    // Prepare the encrypted card fields using the same encryption helper
    Map<String, dynamic> encryptedPassword = {
      'name': password['name'],
      'webpage': password['webpage'],
      'username': await _aesHelper.encryptText(password['username']),
      'password': await _aesHelper.encryptText(password['password']),
      'notes': password['notes'],
      'color': password['color'],
      'favorite': password['favorite'] ? 1 : 0,
    };

    // Update the existing card in the database based on its primary key (id)
    return await db.update(
      'Passwords',                    // Table name
      encryptedPassword,               // Data to update
      where: 'id = ?',             // Condition for which row to update
      whereArgs: [id],             // Arguments for the WHERE clause
    );
  }

  Future<int> deleteCard(int id) async {
    Database db = await database;
    return await db.delete('Cards', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePassword(int id) async {
    Database db = await database;
    return await db.delete('Passwords', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFavoritePasswords() async {
    Database db = await database;

    // Query the Passwords table where favorite = 1
    List<Map<String, dynamic>> favoritePasswords = await db.query(
        'Passwords',
        where: 'favorite = ?',
        whereArgs: [1]
    );

    // Decrypt sensitive fields for each password
    return Future.wait(favoritePasswords.map((password) async {
      return {
        'id': password['id'],
        'name': password['name'],
        'webpage': password['webpage'],
        'username': await _aesHelper.decryptText(password['username']),
        'password': await _aesHelper.decryptText(password['password']),
        'notes': password['notes'],
        'color': password['color'],
        'favorite': password['favorite'] == 1,
        'type': 'password',// Convert integer back to boolean
      };
    }));
  }

}
