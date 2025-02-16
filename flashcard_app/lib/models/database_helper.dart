import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/Deck.dart';
import '../models/FlashCard.dart';

class DatabaseHelper {
  static const _databaseName = "flashcards.db";
  static const _databaseVersion = 1;

  static const tableDeck = 'decks';
  static const tableFlashCard = 'flashcards';

  static Database? _database;

  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Deck table
    await db.execute('''
      CREATE TABLE $tableDeck (
        id TEXT PRIMARY KEY,
        deckName TEXT NOT NULL
      )
    ''');

    // Create FlashCard table
    await db.execute('''
      CREATE TABLE $tableFlashCard (
        id TEXT PRIMARY KEY,
        deckId TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        imageUrl TEXT,
        audioUrl TEXT,
        rating INTEGER DEFAULT 0,
        ts TEXT,
        dueDate TEXT,
        easeFactor REAL DEFAULT 2.5,
        reviews INTEGER DEFAULT 0,
        FOREIGN KEY (deckId) REFERENCES $tableDeck (id) ON DELETE CASCADE
      )
    ''');
  }

  // Add a Deck
  Future<int> insertDeck(Deck deck) async {
    final db = await database;
    return await db.insert(tableDeck, deck.toMap());
  }

  // Get all Decks
  Future<List<Deck>> getDecks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableDeck);
    return maps.map((map) => Deck.fromMap(map)).toList();
  }

  // Add a FlashCard
  Future<int> insertFlashCard(FlashCard flashCard) async {
    final db = await database;
    return await db.insert(tableFlashCard, flashCard.toMap());
  }

  // Get FlashCards by Deck ID
  Future<List<FlashCard>> getFlashCards(String deckId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableFlashCard,
      where: 'deckId = ?',
      whereArgs: [deckId],
    );
    return maps.map((map) => FlashCard.fromMap(map)).toList();
  }

  // Delete a Deck and its FlashCards
  Future<int> deleteDeck(String deckId) async {
    final db = await database;
    return await db.delete(tableDeck, where: 'id = ?', whereArgs: [deckId]);
  }

  // Delete a FlashCard
  Future<int> deleteFlashCard(String id) async {
    final db = await database;
    return await db.delete(tableFlashCard, where: 'id = ?', whereArgs: [id]);
  }
}
