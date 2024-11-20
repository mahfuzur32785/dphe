import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class Beneficiary {
  final int id;
  final String name;
  final String phone;
  // ... other fields

  Beneficiary({
    required this.id,
    required this.name,
    required this.phone,
    // ... other fields
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      // ... other fields
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      // ... other fields
    };
  }
}

class DatabaseHelper {
  static const String dbName = 'your_database.db';
  static const String tableName = 'beneficiaries';

  late Database _database;

  Future<void> initializeDatabase() async {
    _database = await openDatabase(dbName, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            name TEXT,
            phone TEXT,
            -- Add other fields here
          )
          ''');
        });
  }

  Future<List<Beneficiary>> fetchPaginatedBeneficiaries(int page, int perPage) async {
    final offset = (page - 1) * perPage;
    final List<Map<String, dynamic>> queryResult = await _database.query(
      tableName,
      limit: perPage,
      offset: offset,
    );
    return queryResult.map((map) => Beneficiary.fromJson(map)).toList();
  }
}

void main() async {
  final dbHelper = DatabaseHelper();
  await dbHelper.initializeDatabase();

  // Replace these variables with actual pagination values
  final page = 1;
  final perPage = 10;

  final beneficiaries = await dbHelper.fetchPaginatedBeneficiaries(page, perPage);

  final responseData = {
    'data': beneficiaries.map((beneficiary) => beneficiary.toJson()).toList(),
    'links': {
      'first': 'http://192.168.10.108/api/get-beneficiaries?page=1',
      'last': 'http://192.168.10.108/api/get-beneficiaries?page=1',
      'prev': null,
      'next': null,
    },
    'meta': {
      'current_page': page,
      'from': (page - 1) * perPage + 1,
      'last_page': 1,
      'links': [
        {
          'url': null,
          'label': '&laquo; Previous',
          'active': false,
        },
        {
          'url': 'http://192.168.10.108/api/get-beneficiaries?page=1',
          'label': '1',
          'active': true,
        },
        {
          'url': null,
          'label': 'Next &raquo;',
          'active': false,
        },
      ],
      'path': 'http://192.168.10.108/api/get-beneficiaries',
      'per_page': perPage,
      'to': (page - 1) * perPage + beneficiaries.length,
      'total': 2,
    }
  };

  final responseJson = jsonEncode(responseData);
  print(responseJson);
}
