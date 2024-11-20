import 'package:dphe/offline_database/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../offline_models/le_offline_models/le_qsn_ans_model.dart';

class LeQsnAnsTable{

  final tableName = "LeQsnAnsTable";

  // Future<void> createTable(Database database) async{
  //   await database.execute(
  //       """CREATE TABLE IF NOT EXISTS $tableName (
  //       "beneficiary_id" INTEGER PRIMARY KEY,
  //       "ans_1" INTEGER DEFAULT '0',
  //       "ans_2" INTEGER DEFAULT '0',
  //       "ans_3" INTEGER DEFAULT '0',
  //       "ans_4" INTEGER DEFAULT '0',
  //       "ans_5" INTEGER DEFAULT '0',
  //       "ans_6" INTEGER DEFAULT '0',
  //       "lat" TEXT DEFAULT NULL,
  //       "long" TEXT DEFAULT NULL,
  //       "image" TEXT DEFAULT NULL,
  //       "is_sync" INTEGER DEFAULT '0',
  //       "created_at" TEXT DEFAULT NULL,
  //       "updated_at" TEXT DEFAULT NULL,
  //       "deleted_at" TEXT DEFAULT NULL
  //     );"""
  //   );

  // }
    Future<void> createTable(Database database) async{
    await database.execute(
        """CREATE TABLE IF NOT EXISTS $tableName (
        "beneficiary_id" INTEGER PRIMARY KEY,
        "jsonans" TEXT DEFAULT NULL,
        
       
        "lat" TEXT DEFAULT NULL,
        "long" TEXT DEFAULT NULL,
        "image" TEXT DEFAULT NULL,
        "is_sync" INTEGER DEFAULT '0',
        "created_at" TEXT DEFAULT NULL,
        "updated_at" TEXT DEFAULT NULL,
        "deleted_at" TEXT DEFAULT NULL
      );"""
    );

  }


  Future<int> insertAns({
    required int beneficiaryId,
    required String jsonAns,
    // required int ans2,
    // required int ans3,
    // required int ans4,
    // required int ans5,
    // required int ans6,
    required String lat,
    required String long,
    required String image,
  })async{
    try{
      final database = await DatabaseHelper().database;
      return await database.insert(
          tableName,
          {
            "beneficiary_id":beneficiaryId,
             "jsonans" : jsonAns,
           
            "lat":lat,
            "long":long,
            "image":image,
            "created_at":DateTime.now().toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }catch(e){
      print(e);
    }
    return 0;
  }


  Future<int> updateQsnAns({
    required int beneficiaryId,
    int? isSync
  })async{
    try{
      final database = await DatabaseHelper().database;
      return await database.update(
          tableName,
          {
            if (isSync!=null) "is_sync":isSync,
            "updated_at":DateTime.now().toString()
          },
          where: "beneficiary_id = ?",
          conflictAlgorithm: ConflictAlgorithm.replace,
          whereArgs: [beneficiaryId]
      );
    }catch(e){
      print(e);
    }
    return 0;
  }



  // to delete a single table
  dropTable() async{
    final database = await DatabaseHelper().database;
    database.execute('DROP TABLE $tableName');
  }



  /// table all list
  Future<List<LeQsnAnsModel>> getAllQsnAnsList() async {
    final database = await DatabaseHelper().database;
    final List<Map<String, dynamic>> dataMaps = await database.query(tableName); // Fetch all data from the table
    return List.generate(dataMaps.length, (i) {
      return LeQsnAnsModel.fromJson(dataMaps[i]);
    });
  }

  /// not sync table all list
  Future<List<LeQsnAnsModel>> fetchNotSyncAnsList() async {
    final database = await DatabaseHelper().database;
    final whereClause = StringBuffer();
    final List<LeQsnAnsModel> results = [];
    whereClause.write('is_sync = 0');
      List<Map<String, dynamic>> queryResult = await database.query(
        tableName,
        where: whereClause.isNotEmpty ? whereClause.toString() : null,
      );
      //return queryResult.map((map) => NonSelectedBeneficiaryListData.fromJson(map)).toList(); /// working code

      for (final map in queryResult) {
        results.add(LeQsnAnsModel.fromJson(map));
      }
      return results;
  }

}