import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:homewwww/models/customer.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bank.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        db.execute('''
          CREATE TABLE customers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            birth_date TEXT,
            balance REAL
          )
        ''');
      },
    );
  }

  Future<int> addCustomer(Customer customer)async{
    final db = await database;
    return await db.insert('customers', customer.toMap());
  }

  Future<List<Customer>> getAllCustomers()async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return maps.map((map) => Customer.fromMap(map)).toList();
  }

  Future<int> updateCustomer(Customer customer)async{
    final db = await database;
    return await db.update(
        'customers',
        customer.toMap(),
        where: 'id = ?',
        whereArgs: [customer.id]
    );
  }

  Future<int> deleteCustomer(int id)async{
    final db = await database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }
}

