import 'package:dphe/offline_database/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../offline_models/le_offline_models/latrine_image_model.dart';

class LatrineProgressTable {
  final tableName = "latrineProgressTable";

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "beneficiary_id" INTEGER UNIQUE,
      "is_completed" INTEGER NOT NULL DEFAULT '0',
      "photo_step_1" TEXT NOT NULL,
      "step_1_sts" TEXT NOT NULL,
      "photo_step_2" TEXT NOT NULL,
      "step_2_sts" TEXT NOT NULL,
      "photo_step_3" TEXT NOT NULL,
      "step_3_sts" TEXT NOT NULL,
      "photo_step_4" TEXT NOT NULL,
      "step_4_sts" TEXT NOT NULL,
      "photo_step_5" TEXT NOT NULL,
      "step_5_sts" TEXT NOT NULL,
      "latitude" TEXT NOT NULL,
      "longitude" TEXT NOT NULL,
      "latitude2" TEXT NOT NULL,
      "longitude2" TEXT NOT NULL,
      "created_at" TEXT DEFAULT NULL,
      "updated_at" TEXT DEFAULT NULL
      );""");
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.

  // Future<int> insert(Map<String, dynamic> row) async {
  //   final database = await DatabaseHelper().database;
  //   return await database.insert(tableName, row);
  // }

  Future<int> insertImage(
      {required int beneficiaryId,
      required int isCompleted,
      required String photoStep1,
      required String photoStep2,
      required String photoStep3,
      required String photoStep4,
      required String photoStep5,
      required String photoStep1sts,
      required String photoStep2sts,
      required String photoStep3sts,
      required String photoStep4sts,
      required String photoStep5sts,
      required String latitude,
      required String longitude,
        required String latitude2,
      required String longitude2,
      }) async {
    try {
      final database = await DatabaseHelper().database;
      return await database.rawInsert(
          """INSERT INTO $tableName (beneficiary_id, is_completed , photo_step_1 , step_1_sts , photo_step_2, step_2_sts , photo_step_3, step_3_sts , photo_step_4 , step_4_sts , photo_step_5 , step_5_sts , latitude, longitude, latitude2, longitude2, created_at , updated_at) 
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
          [beneficiaryId, isCompleted, photoStep1,photoStep1sts, photoStep2,photoStep2sts, photoStep3,photoStep3sts, photoStep4,photoStep4sts, photoStep5,photoStep5sts, latitude, longitude,latitude2,longitude2, DateTime.now().toString(),""]);
    } catch (e) {
      print(e);
    }
    return 0;
  }

  Future<int> updateImage(
      {required int? beneficiaryId,
      int? isCompleted,
      String? photoStep1,
      String? photoStep2,
      String? photoStep3,
      String? photoStep4,
      String? photoStep5,
      String? photoStep1sts,
      String? photoStep2sts,
      String? photoStep3sts,
      String? photoStep4sts,
      String? photoStep5sts,
      String? latitude,
      String? longitude,
      String? latitude2,
      String? longitude2,
      }) async {
    try {
      final database = await DatabaseHelper().database;
      return await database.update(
          tableName,
          {
            if (isCompleted != null) "is_completed": isCompleted,
            if (photoStep1 != null) "photo_step_1": photoStep1,
            if (photoStep1sts != null) "step_1_sts": photoStep1sts,
            if (photoStep2 != null) "photo_step_2": photoStep2,
            if (photoStep2sts != null) "step_2_sts": photoStep2sts,
            if (photoStep3 != null) "photo_step_3": photoStep3,
            if (photoStep3sts != null) "step_3_sts": photoStep3sts,
            if (photoStep4 != null) "photo_step_4": photoStep4,
            if (photoStep4sts != null) "step_4_sts": photoStep4sts,
            if (photoStep5 != null) "photo_step_5": photoStep5,
            if (photoStep5sts != null) "step_5_sts": photoStep5sts,
            if (latitude != null) "latitude": latitude,
            if (longitude != null) "longitude": longitude,
             if (latitude2 != null) "latitude2": latitude2,
            if (longitude2 != null) "longitude2": longitude2,
            "updated_at": DateTime.now().toString()
          },
          where: "beneficiary_id = ?",
          conflictAlgorithm: ConflictAlgorithm.replace,
          whereArgs: [beneficiaryId]);
    } catch (e) {
      print("error update : $e");
    }

    return 0;
  }

  deleteSyncedLatrineProgressImg({required int beneficiaryId}) async {
    final database = await DatabaseHelper().database;
    await database.delete(
      tableName,
      where: "beneficiary_id = ?",
      whereArgs: [beneficiaryId],
    );
  }

  // to delete a single table
  dropTable() async {
    final database = await DatabaseHelper().database;
    database.execute('DROP TABLE $tableName');
  }

  // static getImageByBeneficiaryId({int? dolilId}) async{
  //   final database = await DatabaseHelper().database;
  //   final  resultSet = database.('SELECT * FROM $tableName WHERE dolil_id=$dolilId');
  //   if(resultSet.isNotEmpty){
  //     return resultSet[0];
  //   } else {
  //     return [];
  //   }
  //
  // }

  Future<LatrineImageModel?> getSingleImage({required int beneficiaryId}) async {
    final database = await DatabaseHelper().database;
    final latrineImageModelResponse = await database.rawQuery('''SELECT * from $tableName WHERE beneficiary_id = ?''', [beneficiaryId]);
    if (latrineImageModelResponse.isNotEmpty) {
      return LatrineImageModel.fromJson(latrineImageModelResponse.first);
    } else {
      return null;
    }
  }
}
