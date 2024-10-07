import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'secure_storage.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Passwords table
    await db.execute('''
      CREATE TABLE Passwords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        webpage TEXT NOT NULL,
        username TEXT,
        password TEXT,
        notes TEXT,
        color TEXT
      )
    ''');

    // Create Cards table
    await db.execute('''
      CREATE TABLE Cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        card_holder TEXT,
        card_number TEXT,
        expiration_date TEXT,
        cvv TEXT,
        notes TEXT,
        color TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE Passwords ADD COLUMN color TEXT');
      await db.execute('ALTER TABLE Cards ADD COLUMN color TEXT');
    }
  }

  // Insert a password into the Passwords table
  Future<int> insertPassword(Map<String, dynamic> password) async {
    Database db = await database;
    return await db.insert('Passwords', password);
  }

  // Insert a card into the Cards table
  Future<int> insertCard(Map<String, dynamic> card) async {
    Database db = await database;
    return await db.insert('Cards', card);
  }

  // Retrieve all passwords
  Future<List<Map<String, dynamic>>> getPasswords() async {
    Database db = await database;
    return await db.query('Passwords');
  }

  // Retrieve all cards
  Future<List<Map<String, dynamic>>> getCards() async {
    Database db = await database;
    return await db.query('Cards');
  }

  // Delete a password by ID
  Future<int> deletePassword(int id) async {
    Database db = await database;
    return await db.delete('Passwords', where: 'id = ?', whereArgs: [id]);
  }

  // Delete a card by ID
  Future<int> deleteCard(int id) async {
    Database db = await database;
    return await db.delete('Cards', where: 'id = ?', whereArgs: [id]);
  }

  // Update a password by ID
  Future<int> updatePassword(int id, Map<String, dynamic> password) async {
    Database db = await database;
    return await db.update('Passwords', password, where: 'id = ?', whereArgs: [id]);
  }

  // Update a card by ID
  Future<int> updateCard(int id, Map<String, dynamic> card) async {
    Database db = await database;
    return await db.update('Cards', card, where: 'id = ?', whereArgs: [id]);
  }
}
