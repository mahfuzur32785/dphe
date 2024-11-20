import 'package:sqflite/sqflite.dart';

import '../../Data/models/common_models/union_dropdown_model.dart';
import '../db_helper.dart';

class UnionTable {
  final tableName = "uniontable";

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY,
        "name" TEXT NOT NULL,
        "upazila_id" INTEGER NOT NULL,
        "bn_name" TEXT NOT NULL,
        "created_at" TEXT DEFAULT NULL
        
       
      );""");
  }

  Future<int> insertUnionSql({
    required int id,
    required String name,
    required String bnName,
    int? upaID,
  }) async {
    try {
      final database = await DatabaseHelper().database;

      return await database.insert(
          tableName,
          {
            "id": id,
            "name": name,
            "bn_name": bnName,
            "upazila_id": upaID,
            "created_at": DateTime.now().toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace
          // conflictAlgorithm: ConflictAlgorithm.rollback
          );
    } catch (e) {
      print(e);
      //  await updateBeneficiary(id: id, statusId: statusId);
    }
    return 0;
  }

  deleteUnionTable()async{
    final database = await DatabaseHelper().database;
    database.delete(tableName);
  }

  Future<List<DropdownUnion>> fetchUnion({required int upazillaId}) async {
    final database = await DatabaseHelper().database;
    // Build a where clause for filtering based on the provided values

    //final List<NonSelectedBeneficiaryListData> results = [];
    final List<DropdownUnion> results = [];

    List<Map<String, dynamic>> queryResult = await database.query(tableName, where: 'upazila_id = ?', whereArgs: [upazillaId]);
    //return queryResult.map((map) => NonSelectedBeneficiaryListData.fromJson(map)).toList(); /// working code

    for (final map in queryResult) {
      //results.add(NonSelectedBeneficiaryListData.fromJson(map));
      results.add(DropdownUnion.fromJson(map));
    }
    return results;
  }
}
