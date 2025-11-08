import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'account.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_db != null) return _db!;
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "bank.db");
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        accountHolder TEXT,
        balance REAL
      )
    ''');
  }

  Future<int> insert(Account a) async {
    final db = await database;
    return await db.insert('accounts', a.toMap());
  }

  Future<List<Account>> fetchAll() async {
    final db = await database;
    final data = await db.query('accounts', orderBy: 'id DESC');
    return data.map((e) => Account.fromMap(e)).toList();
  }

  Future<double> totalMoney() async {
    final db = await database;
    final res = await db.rawQuery('SELECT SUM(balance) as total FROM accounts');
    return res.first['total'] == null
        ? 0.0
        : (res.first['total'] as num).toDouble();
  }
}
