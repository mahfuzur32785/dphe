import 'dart:convert';

import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/offline_database/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../../Data/models/le_models/benificiary_models/non_selected_benificiary_list_model.dart';

class BeneficiaryListTable {
  final tableName = "beneficiaryListTable";

  Future<void> createTable(Database database) async {
    // //  "status" INTEGER NOT NULL,
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY,
        "name" TEXT NOT NULL,
        "bangla_name" TEXT NOT NULL,
        "phone" TEXT NOT NULL,
        "type" TEXT NOT NULL,
        "address" TEXT NOT NULL,
        "nid" INTEGER NOT NULL,
        "photo" TEXT NOT NULL,
        "is_send_back" INTEGER DEFAULT NULL,
        "send_back_reason" TEXT DEFAULT NULL,
        "father_or_husband_name" TEXT DEFAULT NULL,
        "comments" TEXT DEFAULT NULL, 
        "religion" TEXT NOT NULL,
        "gender" TEXT NOT NULL,
        "latitude" TEXT NOT NULL,
        "longitude" TEXT NOT NULL,
        "division_id" INTEGER NOT NULL,
        "district_id" INTEGER NOT NULL,
        "upazila_id" INTEGER NOT NULL,
        "union_id" INTEGER DEFAULT NULL,
        "ward_no" TEXT DEFAULT NULL,
        "user_id" INTEGER DEFAULT NULL,
        "status_id" INTEGER NOT NULL DEFAULT '0',
        "otp_verified" INTEGER NOT NULL DEFAULT '0',
        "is_question_answer" INTEGER NOT NULL DEFAULT '0',
        "is_location_match" INTEGER NOT NULL DEFAULT '0',
        "division_name" TEXT NOT NULL,
        "district_name" TEXT NOT NULL,
        "upazila_name" TEXT NOT NULL,
        "union_name" TEXT NOT NULL,
        "junction" TEXT DEFAULT NULL,
        "district" TEXT NOT NULL,
        "upazila" TEXT NOT NULL,
        "union" TEXT NOT NULL,
        "created_by" INTEGER DEFAULT NULL,
        "updated_by" INTEGER DEFAULT NULL,
        "deleted_by" INTEGER DEFAULT NULL,
        "created_at" TEXT DEFAULT NULL,
        "updated_at" TEXT DEFAULT NULL,
        "deleted_at" TEXT DEFAULT NULL
      );""");
  }

  Future<int> insertBeneficiary(
      {required int id,
      required String name,
      required String phone,
      required String banglaName,
      required String type,
      required String address,
      required dynamic nid,
      required String photo,
      required String sendBackReason,
      required String junction,
      // required dynamic status,
      required String religion,
      required String gender,
      required dynamic latitude,
      required dynamic longitude,
      required int divisionId,
      required int districtId,
      required int upazilaId,
      required int unionId,
      String? wardId,
      required int userId,
      required int statusId,
      required int otpVerified,
      int? isSendBack,
      String? sendBackComments,
      required int isQuestionAnswer,
      required int isLocationMatch,
      required dynamic district,
      required String fatherOrHusbandName,
      required dynamic upazila,
      required dynamic union,
      required String divisionName,
      required String districtName,
      required String upazilaName,
      required String unionName,
      required dynamic createdBy,
      required dynamic updatedBy,
      required dynamic deletedBy}) async {
    try {
      final database = await DatabaseHelper().database;
      // final Map<String, dynamic> divisionMap = division.toJson();
      // final Map<String, dynamic> districtMap = district.toJson();
      // final Map<String, dynamic> upazilaMap = upazila.toJson();
      // final Map<String, dynamic> unionMap = union.toJson();
      return await database.insert(
          tableName,
          {
            "id": id,
            "name": name,
            "bangla_name":banglaName,
            "phone": phone,
            "type": type,
            "address": address,
            "nid": nid,
            "photo": photo,
            "is_send_back": isSendBack,
            "send_back_reason": sendBackReason,
            "father_or_husband_name": fatherOrHusbandName,
            //"status":status,
            "religion": religion,
            "gender": gender,
            "latitude": latitude,
            "longitude": longitude,
            "division_id": divisionId,
            "district_id": districtId,
            "upazila_id": upazilaId,
            "union_id": unionId,
            "ward_no": wardId,
            "user_id": userId,
            "status_id": statusId,
            "otp_verified": otpVerified,
            "comments": sendBackComments,
            "is_question_answer": isQuestionAnswer,
            "is_location_match": isLocationMatch,

            "district": jsonEncode(district),
            "upazila": jsonEncode(upazila),
            "union": jsonEncode(union),
            "division_name": divisionName,
            "district_name": districtName,
            "upazila_name": upazilaName,
            "union_name": unionName,
            "junction":junction,
            "created_by": createdBy,
            "updated_by": updatedBy,
            "deleted_by": deletedBy,
            "created_at": DateTime.now().toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace
          // conflictAlgorithm: ConflictAlgorithm.rollback
          );
    } catch (e) {
      print(e);
      await updateBeneficiary(id: id, statusId: statusId);
    }
    return 0;
  }

  Future<int> updateBeneficiary(
      {required int id,
      String? photo,
      // dynamic status,
      String? latitude,
      String? longitude,
      int? statusId,
      int? otpVerified,
      int? isQuestionAnswer,
      int? isLocationMatch,
      String? createdBy,
      String? updatedBy,
      String? deletedBy}) async {
    try {
      final database = await DatabaseHelper().database;
      return await database.update(
          tableName,
          {
            if (photo != null) "photo": photo,
            //  if (status!=null) "status":status,
            if (latitude != null) "latitude": latitude,
            if (longitude != null) "longitude": longitude,
            if (statusId != null) "status_id": statusId,
            if (otpVerified != null) "otp_verified": otpVerified,
            if (isQuestionAnswer != null) "is_question_answer": isQuestionAnswer,
            if (isLocationMatch != null) "is_location_match": isLocationMatch,
            if (createdBy != null) "created_by": createdBy,
            if (updatedBy != null) "updated_by": updatedBy,
            if (deletedBy != null) "deleted_by": deletedBy,
            "updated_at": DateTime.now().toString()
          },
          where: "id = ?",
          conflictAlgorithm: ConflictAlgorithm.replace,
          whereArgs: [id]);
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
      String? latitude,
      String? longitude}) async {
    try {
      final database = await DatabaseHelper().database;
      return await database.update(
          tableName,
          {
            if (isCompleted != null) "is_completed": isCompleted,
            if (photoStep1 != null) "photo_step_1": photoStep1,
            if (photoStep2 != null) "photo_step_2": photoStep2,
            if (photoStep3 != null) "photo_step_3": photoStep3,
            if (photoStep4 != null) "photo_step_4": photoStep4,
            if (photoStep5 != null) "photo_step_5": photoStep5,
            if (latitude != null) "latitude": latitude,
            if (longitude != null) "longitude": longitude,
            "updated_at": DateTime.now().toString()
          },
          where: "id = ?",
          conflictAlgorithm: ConflictAlgorithm.replace,
          whereArgs: [beneficiaryId]);
    } catch (e) {
      print("error update : $e");
    }

    return 0;
  }

  // to delete a single table
  dropTable() async {
    final database = await DatabaseHelper().database;
    database.execute('DROP TABLE $tableName');
  }

  Future<BeneficiaryDetailsData> getSingleBeneficiary({required int beneficiaryId}) async {
    final database = await DatabaseHelper().database;
    final beneficiaryModelResponse = await database.rawQuery('''SELECT * from $tableName WHERE id = ?''', [beneficiaryId]);
    return BeneficiaryDetailsData.fromJson(beneficiaryModelResponse.first);
  }

  // Future<List<NonSelectedBeneficiaryListData>> fetchPaginatedBeneficiaries(int page, int perPage) async {
  //   final offset = (page - 1) * perPage;
  //   final database = await DatabaseHelper().database;
  //   final List<Map<String, dynamic>> queryResult = await database.query(
  //     tableName,
  //     limit: perPage,
  //     offset: offset,
  //   );
  //   return queryResult.map((map) => NonSelectedBeneficiaryListData.fromJson(map)).toList();
  // }

  /// with union id
  Future<List<BeneficiaryDetailsData>> fetchPaginatedBeneficiaries(int page, int perPage, List statusId,
      {int upazillaId = -10, int unionId = -10}) async {
    final offset = (page - 1) * perPage;
    final database = await DatabaseHelper().database;
    // Build a where clause for filtering based on the provided values
    final whereClause = StringBuffer();
    //final List<NonSelectedBeneficiaryListData> results = [];
    final List<BeneficiaryDetailsData> results = [];
    if (statusId.isNotEmpty) {
      if (statusId.length == 2) {
        whereClause.write('status_id = ${statusId[0]}'); // here 0 is index number
        whereClause.write(' OR ');
        whereClause.write('status_id = ${statusId[1]}'); // here 1 is index number
      } else if (statusId.length == 4) {
        whereClause.write('status_id = ${statusId[0]}'); // here 0 is index number
        whereClause.write(' OR ');
        whereClause.write('status_id = ${statusId[1]}'); // here 1 is index number
        whereClause.write(' OR ');
        whereClause.write('status_id = ${statusId[2]}'); // here 2 is index number
        whereClause.write(' OR ');
        whereClause.write('status_id = ${statusId[3]}'); // here 3 is index number
      } else {
        whereClause.write('status_id = ${statusId[0]}'); // here 0 is index number
      }

      if (upazillaId != -10) {
        if (whereClause.isNotEmpty) {
          whereClause.write(' AND ');
        }
        whereClause.write('upazila_id = $upazillaId');
      }

      if (unionId != -10) {
        if (whereClause.isNotEmpty) {
          whereClause.write(' AND ');
        }
        whereClause.write('union_id = $unionId');
      }
      List<Map<String, dynamic>> queryResult = await database.query(
        tableName,
        // limit: perPage,
        // offset: offset,
        where: whereClause.isNotEmpty ? whereClause.toString() : null,
      );
      //return queryResult.map((map) => NonSelectedBeneficiaryListData.fromJson(map)).toList(); /// working code

      for (final map in queryResult) {
        //results.add(NonSelectedBeneficiaryListData.fromJson(map));
        results.add(BeneficiaryDetailsData.fromJson(map));
      }
      return results;
    }
    return results;
  }

  /// fetch all beneficiary with query
  Future<List<BeneficiaryDetailsData>> fetchAllBeneficiaries(List statusId) async {
    final database = await DatabaseHelper().database;
    // Build a where clause for filtering based on the provided values
    final whereClause = StringBuffer();
    final List<BeneficiaryDetailsData> results = [];
    if (statusId.isNotEmpty) {
      if (statusId.length == 2) {
        whereClause.write('status_id = ${statusId[0]}'); // here 0 is index number
        whereClause.write(' OR ');
        whereClause.write('status_id = ${statusId[1]}'); // here 1 is index number
      } else if (statusId.length == 4) {
        whereClause.write('status_id = ${statusId[0]}'); // here 0 is index number
        whereClause.write(' OR ');
        whereClause.write('status_id = ${statusId[1]}'); // here 1 is index number
        whereClause.write(' OR ');
        whereClause.write('status_id = ${statusId[2]}'); // here 2 is index number
        whereClause.write(' OR ');
        whereClause.write('status_id = ${statusId[3]}');
      } else {
        whereClause.write('status_id = ${statusId[0]}');
      }

      print(statusId[0]);
      List<Map<String, dynamic>> queryResult = await database.query(
        tableName,
        where: whereClause.isNotEmpty ? whereClause.toString() : null,
      );
      //return queryResult.map((map) => NonSelectedBeneficiaryListData.fromJson(map)).toList(); /// working code

      for (final map in queryResult) {
        results.add(BeneficiaryDetailsData.fromJson(map));
      }
      return results;
    }
    return results;
  }

  deleteSyncedBenf(int id) async {
    final database = await DatabaseHelper().database;
    await database.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  deleteNonSelectedBenficiaries(int id) async {
    final database = await DatabaseHelper().database;
    await database.delete(
      tableName,
      where: "status_id = ?",
      whereArgs: [id],
    );
  }

  /// new table all list
  Future<List<BeneficiaryDetailsData>> getAllData() async {
    final database = await DatabaseHelper().database;
    final List<Map<String, dynamic>> dataMaps = await database.query(tableName); // Fetch all data from the table
    return List.generate(dataMaps.length, (i) {
      return BeneficiaryDetailsData.fromJson(dataMaps[i]);
    });
  }
}
