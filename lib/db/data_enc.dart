import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:passwordmanager/global_dirs.dart';
// Assuming AESHelper is defined

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  final AESHelper _aesHelper = AESHelper();
  String? _userId; // This will store the unique user ID or email

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Set the current user
  void setUser(String userId) {
    _userId = userId;
    _database = null; // Reset the database when a new user is set
  }

  // Ensure the user is set before accessing the database
  Future<Database> get database async {
    if (_userId == null) {
      throw Exception(
          'User not set. Call setUser(userId) before accessing the database.');
    }

    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Create a unique database for each user
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentsDirectory.path, 'secure_data_$_userId.db'); // Unique per user
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> deleteDatabaseFile(String userId) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(
        documentsDirectory.path, 'secure_data_$userId.db'); // Unique per user

    // Delete the database file
    File dbFile = File(dbPath);
    if (await dbFile.exists()) {
      await dbFile.delete();
      print("Database file deleted successfully.");
    } else {
      print("Database file does not exist.");
    }
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
    List<Map<String, dynamic>> results =
        await db.query('Passwords', where: 'id = ?', whereArgs: [id]);
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
      'Passwords', // Table name
      encryptedPassword, // Data to update
      where: 'id = ?', // Condition for which row to update
      whereArgs: [id], // Arguments for the WHERE clause
    );
  }

  Future<int> deletePassword(int id) async {
    Database db = await database;
    return await db.delete('Passwords', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFavoritePasswords() async {
    Database db = await database;

    // Query the Passwords table where favorite = 1
    List<Map<String, dynamic>> favoritePasswords =
        await db.query('Passwords', where: 'favorite = ?', whereArgs: [1]);

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
        'type': 'password', // Convert integer back to boolean
      };
    }));
  }

  Future<void> reencryptPasswords(String key) async {
    Database db = await database;

    // Retrieve all password records
    List<Map<String, dynamic>> passwords = await db.query('Passwords');


    // Single loop: decrypt and re-encrypt, then store in the list
    for (var password in passwords) {
      // Decrypt fields
      String decryptedUsername = await _aesHelper.decryptText(password['username']);
      String decryptedPassword = await _aesHelper.decryptText(password['password']);

      // Re-encrypt fields
      String encryptedUsername = await _aesHelper.encryptText(decryptedUsername,key);
      String encryptedPassword = await _aesHelper.encryptText(decryptedPassword,key);

      await db.update(
        'Passwords',                    // Table name
        {
          'username': encryptedUsername, // Update with re-encrypted username
          'password': encryptedPassword, // Update with re-encrypted password
          // Keep other fields unchanged
          'name': password['name'],
          'webpage': password['webpage'],
          'notes': password['notes'],
          'color': password['color'],
          'favorite': password['favorite'], // Store original favorite value
        },
        where: 'id = ?',                 // Condition for which row to update
        whereArgs: [password['id']],     // Arguments for the WHERE clause
      );
    }
  }


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

  Future<int> deleteCard(int id) async {
    Database db = await database;
    return await db.delete('Cards', where: 'id = ?', whereArgs: [id]);
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
        'expiration_date':
            await _aesHelper.decryptText(card['expiration_date']),
        'cvv': await _aesHelper.decryptText(card['cvv']),
        'notes': card['notes'],
        'color': card['color'],
        'favorite': card['favorite'] == 1,
      };
    }));
  }

  Future<List<Map<String, dynamic>>> getFavoriteCards() async {
    Database db = await database;
    List<Map<String, dynamic>> favoriteCards =
        await db.query('Cards', where: 'favorite = ?', whereArgs: [1]);
    return Future.wait(favoriteCards.map((card) async {
      return {
        'id': card['id'],
        'name': card['name'],
        'card_holder': await _aesHelper.decryptText(card['card_holder']),
        'card_number': await _aesHelper.decryptText(card['card_number']),
        'expiration_date':
            await _aesHelper.decryptText(card['expiration_date']),
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
    List<Map<String, dynamic>> results =
        await db.query('Cards', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      Map<String, dynamic> card = results.first;
      return {
        'id': card['id'],
        'name': card['name'],
        'card_holder': await _aesHelper.decryptText(card['card_holder']),
        'card_number': await _aesHelper.decryptText(card['card_number']),
        'expiration_date':
            await _aesHelper.decryptText(card['expiration_date']),
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
      'Cards', // Table name
      encryptedCard, // Data to update
      where: 'id = ?', // Condition for which row to update
      whereArgs: [id], // Arguments for the WHERE clause
    );
  }

  Future<void> reencryptCards(String key) async {
    Database db = await database;

    // Retrieve all card records
    List<Map<String, dynamic>> cards = await db.query('Cards');

    // Create a list to hold the processed cards
    List<Map<String, dynamic>> processedCards = [];

    // Single loop: decrypt and re-encrypt, then store in the list
    for (var card in cards) {
      // Decrypt fields
      String decryptedCardHolder = await _aesHelper.decryptText(card['card_holder']);
      String decryptedCardNumber = await _aesHelper.decryptText(card['card_number']);
      String decryptedExpirationDate = await _aesHelper.decryptText(card['expiration_date']);
      String decryptedCvv = await _aesHelper.decryptText(card['cvv']);

      // Re-encrypt fields
      String encryptedCardHolder = await _aesHelper.encryptText(decryptedCardHolder,key);
      String encryptedCardNumber = await _aesHelper.encryptText(decryptedCardNumber,key);
      String encryptedExpirationDate = await _aesHelper.encryptText(decryptedExpirationDate,key);
      String encryptedCvv = await _aesHelper.encryptText(decryptedCvv,key);

      await db.update(
        'Cards',                       // Table name
        {
          'card_holder': encryptedCardHolder, // Update with re-encrypted card holder
          'card_number': encryptedCardNumber, // Update with re-encrypted card number
          'expiration_date': encryptedExpirationDate, // Update with re-encrypted expiration date
          'cvv': encryptedCvv,             // Update with re-encrypted CVV
          // Keep other fields unchanged
          'name': card['name'],
          'notes': card['notes'],
          'color': card['color'],
          'favorite': card['favorite'], // Store original favorite value
        },
        where: 'id = ?',                 // Condition for which row to update
        whereArgs: [card['id']],         // Arguments for the WHERE clause
      );
    }
  }


  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<void> exportDatabaseToDownloads() async {
    try {
      // Ensure storage permission is granted
      PermissionStatus permission = await Permission.storage.request();
      if (!permission.isGranted) {
        print('Storage permission not granted');
        return;
      }

      // Get the app's internal database file path
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String dbPath = join(documentsDirectory.path,
          'secure_data_$_userId.db'); // Ensure you set the userId

      File dbFile = File(dbPath);

      if (!(await dbFile.exists())) {
        print('Database file does not exist.');
        return;
      }

      // Get the path to the Downloads directory
      String? downloadsDirectory = await getDownloadPath();

      if (downloadsDirectory == null) {
        print('Failed to get Downloads directory.');
        return;
      }

      String downloadsPath =
          join(downloadsDirectory, 'secure_data_$_userId.db');

      // Copy the database file to the Downloads directory
      await dbFile.copy(downloadsPath);
      print('Database file exported to Downloads: $downloadsPath');
    } catch (e) {
      print('Error exporting database: $e');
    }
  }

  // Function to request storage permission for Android
  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception("Storage permission denied");
    }
  }
}
