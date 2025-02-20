import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    String path = join(await getDatabasesPath(), 'cadastro-flutter.db');
    print('Caminho do banco de dados: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  //Recurso que cria as tabelas de cadastro e log_operacoes
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cadastro(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        texto TEXT NOT NULL,
        numero INTEGER NOT NULL UNIQUE CHECK(numero > 0)
      )
    ''');

    await db.execute('''
      CREATE TABLE log_operacoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo_operacao TEXT NOT NULL,
        data_hora TEXT NOT NULL
      )
    ''');

    //Cria triggers para registrar os logs automaticamente
    await _createTriggers(db);
  }

  Future<void> _createTriggers(Database db) async {
    //Trigger para o INSERT
    await db.execute('''
      CREATE TRIGGER IF NOT EXISTS log_insert AFTER INSERT ON cadastro
      BEGIN
        INSERT INTO log_operacoes(tipo_operacao, data_hora)
        VALUES ('Insert', datetime('now'));
      END;
    ''');

    //Trigger para o UPDATE
    await db.execute('''
      CREATE TRIGGER IF NOT EXISTS log_update AFTER UPDATE ON cadastro
      BEGIN
        INSERT INTO log_operacoes(tipo_operacao, data_hora)
        VALUES ('Update', datetime('now'));
      END
    ''');

    //Trigger para o DELETE
    await db.execute('''
      CREATE TRIGGER IF NOT EXISTS log_delete AFTER DELETE ON cadastro
      BEGIN
        INSERT INTO log_operacoes(tipo_operacao, data_hora)
        VALUES ('Delete', datetime('now'));
      END;
    ''');
  }

  /*
  Insere um novo cadastro utilizando o parâmetro Map que contêm os dados 
  a serem inseridos como texto e numero.
  */
  Future<int> insertCadastro(Map<String, dynamic> row) async {
    Database db = await _instance.database;
    return await db.insert('cadastro', row);
  }

  //Atualiza um cadastro existente
  Future<int> updateCadastro(int id, Map<String, dynamic> row) async {
    Database db = await _instance.database;
    print('Atualizando registro $id com valores: $row');
    return await db.update(
      'cadastro',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Deleta um cadastro já existente
  Future<int> deleteCadastro(int id) async {
    Database db = await _instance.database;
    return await db.delete(
      'cadastro',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Consulta o registro de todos os cadastros
  Future<List<Map<String, dynamic>>> queryAllCadastros() async {
    Database db = await _instance.database;
    return await db.query('cadastro');
  }
}
