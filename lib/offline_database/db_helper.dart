import 'package:dphe/offline_database/db_tables/le_tables/beneficiary_list_table.dart';
import 'package:dphe/offline_database/db_tables/union_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_tables/le_tables/latrine_progress_table.dart';
import 'db_tables/le_tables/le_qsn_ans_table.dart';

class DatabaseHelper{
  Database? _database;
  Future<Database> get database async{
    if(_database !=null){
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async{
    const name = "dpheDatabase.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async{
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  // to create all the tables
  Future<void> create(Database database, int version) async {
    await LatrineProgressTable().createTable(database);
    await BeneficiaryListTable().createTable(database);
    await LeQsnAnsTable().createTable(database);
    await UnionTable().createTable(database);

  }

}