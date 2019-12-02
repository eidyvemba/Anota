import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AnotacaoDB {
  static Database db;


  static Future open() async{
    /*var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'anotacoes.db');
    await deleteDatabase(path);*/
    db = await openDatabase(
        join(await getDatabasesPath(), 'notas.db'),
        version: 1,
        onCreate: (Database db, int version) async{
          db.execute('''
            create table Anotacoes(
              id integer primary key autoincrement,
              titulo text not null,
              texto text not null,
              data_criacao datetime null,
              data_edicao datetime null,
              status int not null
            );
          ''');
        }
    );
  }

  static Future<List<Map<String, dynamic>>> getAnotacoesList() async{
    if (db == null){
      await open();
    }
    return await db.query('Anotacoes');
  }

  static Future insereAnotacao(Map<String, dynamic> anotacao) async{
    await db.insert('Anotacoes', anotacao);
  }

  static Future updateAnotacao(Map<String, dynamic> anotacao) async{
    await db.update(
        'Anotacoes',
        anotacao,
      where: 'id = ?',
      whereArgs: [anotacao['id']]
    );
  }

  static Future apagarAnotacao(int id) async{
    await db.delete(
        'Anotacoes',
        where: 'id = ?',
        whereArgs: [id]
    );
  }
}