
import 'dart:convert';
import 'dart:io';

import 'package:dphe/Data/models/common_models/union_dropdown_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../Data/models/common_models/upazila_dropdown_model.dart';

class CommonFunctions{
 static String convertNumberToBangla(dynamic eng) {
    String bangla = '';
    for (int i = 0; i < eng.toString().length; i++) {
      switch (eng.toString()[i]) {
        case '1':
          bangla = '$bangla১';
          break;
        case '2':
          bangla = '$bangla২';
          break;
        case '3':
          bangla = '$bangla৩';
          break;
        case '4':
          bangla = '$bangla৪';
          break;
        case '5':
          bangla = '$bangla৫';
          break;
        case '6':
          bangla = '$bangla৬';
          break;
        case '7':
          bangla = '$bangla৭';
          break;
        case '8':
          bangla = '$bangla৮';
          break;
        case '9':
          bangla = '$bangla৯';
          break;

        case '১':
          bangla = '$bangla 1';
          break;
        case '২':
          bangla = '$bangla 2';
          break;
        case '৩':
          bangla = '$bangla 3';
          break;
        case '৪':
          bangla = '$bangla 4';
          break;
        case '৫':
          bangla = '$bangla 5';
          break;
        case '৬':
          bangla = '$bangla 6';
          break;
        case '৭':
          bangla = '$bangla 7';
          break;
        case '৮':
          bangla = '$bangla 8';
          break;
        case '৯':
          bangla = '$bangla 9';
          break;

        case '-':
          bangla = '$bangla-';
          break;
        case ' ':
          bangla = '$bangla';
          break;
        case '.':
          bangla = '$bangla.';
          break;
        default:
          bangla = '$bangla০';
      }
    }
    return bangla;
  }




  // get upazilla data
  Future<UpazilaDropdownModel?> getUpazilaJsonData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json_files/all_upazila.json');
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return UpazilaDropdownModel.fromJson(jsonMap);

    } catch (e) {
      print('Error retrieving JSON data from local storage: $e');
    }
    return null;
  }

  // get union data
  Future<UnionDropdownModel?> getUnionJsonData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json_files/all_union.json');
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UnionDropdownModel.fromJson(jsonMap);

    } catch (e) {
      print('Error retrieving JSON data from local storage: $e');
    }
    return null;
  }
}