import 'dart:convert';
import 'dart:developer';

import 'package:dphe/Data/models/hiveDbModel/dlc_que_ans.dart';
import 'package:dphe/Data/models/hiveDbModel/upazilla_hive_model.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../Data/models/hiveDbModel/activity_form_model.dart';
import '../Data/models/hiveDbModel/dlc_ph_verify_model.dart';
import '../components/custom_snackbar/custom_snakcbar.dart';

class LocalStoreHiveProvider extends ChangeNotifier {
  Box? permissionBox = Hive.box('user_permission');

  Box<ActivityFormModel> activitiesBox = Hive.box<ActivityFormModel>('dlcactivity');
  Box<LocalDlcQuesAns> dlcQABox = Hive.box<LocalDlcQuesAns>('dlcqa');

  initActivityBox(String activityStatus) {
    var activities = activitiesBox.values.toList();

    if (activities.isEmpty) {
      activitiesBox.add(ActivityFormModel(
          actStatus: activityStatus,
          activityID: -1,
          activityType: '',
          attended: -1,
          completedBatch: -1,
          date: '',
          districtID: -1,
          limitation: '',
          recmmended: '',
          rmrk: '',
          stkHolder: '',
          targetParticipant: -1,
          unioniD: -1));
    } else {
      return;
    }
    //notifyListeners();
  }

  updateActivity({String? statusName, required ActivityFormModel activityFormData}) {
    int index = -1;
    index = activitiesBox.values.toList().indexWhere((g) => g.actStatus == statusName);
    if (index == -1) {
      return;
    } else {
      activitiesBox.putAt(index, activityFormData);
      //existingform = activityFormData;
    }

    notifyListeners();
  }

  storeUserPermission({String permissions = ''}) {
    if (permissions.isNotEmpty) {
      permissionBox!.put('permission', permissions);
    }
  }

  List<dynamic> getUserPermission() {
    List<dynamic> permissionList = [];
    var permission = permissionBox!.get('permission');
    permissionList = jsonDecode(permission);
    return permissionList;
  }

  deleteAllPermission() {
    permissionBox!.clear();
  }

  Box<PhysicalVerifyModelHive> phVerifBox = Hive.box('physmodel');
  Box<UpazillaHiveModel> upazilaBox = Hive.box('upazilahv');

// storePhVerifBox(){
//   phVerifBox.putAll(entries)
// }

  storeUpazilla({required UpazillaHiveModel upazilla}) {
    if (!upazilaBox.values.any(
      (element) => element.id == upazilla.id,
    )) {
      upazilaBox.add(upazilla);
    } else {
      return;
    }
    notifyListeners();
  }

  List<UpazillaHiveModel> _upazillaHiveList = [];
  List<UpazillaHiveModel> get upazillaHiveList => _upazillaHiveList;

  retrieveUpazilla({required int distID}) {
    upazillaHiveList.clear();
    notifyListeners();
    _upazillaHiveList = upazilaBox.values.where((element) => element.districtID == distID).toList();

    notifyListeners();
  }

  storeDataForPhysicalVerificatiojn({required PhysicalVerifyModelHive phvmodel}) {
    var phver = phVerifBox.values.toList();

    if (!phver.any((element) => element.id == phvmodel.benfID)) {
      phVerifBox.add(phvmodel);
      //phVerifBox.values.toList();
    } else {
      return;
    }

    //phVerifBox.clear();

    notifyListeners();
  }

  updateLocalPhysicalVerifyStatus({
    //required int index,
    required int benfiD,
    required String latitude,
    required String longitude,
    required String status,
    String? reason,
    required String qansJson,
    required int distID,
    required int upaiD,
    required String isOnline,
  }) {
    int index = -1;
    // final phVerifData = phVerifBox.getAt(index);
    final phVerifData = phVerifBox.values.toList();
    if (phVerifData.isEmpty) {
      return;
    }
    index = phVerifData.indexWhere((element) => element.benfID == benfiD);
    if (index != -1) {
      var updphVerifData = PhysicalVerifyModelHive(
          isOnline: isOnline, //'offlineDrafted',
          benfID: benfiD,
          latitude: latitude,
          longitude: longitude,
          status: status,
          reason: reason,
          qansjson: qansJson,
          distID: distID,
          upazillaID: upaiD);
      phVerifBox.putAt(index, updphVerifData);
      // var phlist = phVerifBox.values.toList();
    }
    //var phVerifData = phVerifBox.getAt(index);

    notifyListeners();
  }

  backupDlcVerification(OperationProvider op) async {
    final phVerifData = phVerifBox.values.toList();
    int delIndex = -1;
    if (phVerifData.isEmpty) {
      return;
    } else {
      for (var phVerif in phVerifData) {
        if (phVerif.isOnline == 'offlineDrafted') {
          final isSuccess = await op.physicalVerifyBeneficiary(
              id: phVerif.benfID!,
              status: phVerif.status!,
              reason: phVerif.reason,
              latitude: phVerif.latitude!,
              longitude: phVerif.longitude!,
              dlcQuestion: phVerif.qansjson!);
          if (isSuccess) {
            //phVerifBox.deleteAt(index)
             delIndex = phVerifBox.values.toList().indexWhere((element) => element.benfID == phVerif.benfID!);
             if (delIndex != -1) {
               phVerifBox.deleteAt(delIndex);
             }
            
            op.paginatedRefresh();
            //  op.fetchPaginatedBenfData(distID: phVerif.distID!, upazilaID: phVerif.upazillaID!, isSearch: false, statusID: 1, local: this);
            CustomSnackBar(message: "Backup Success", isSuccess: true).show();
          } else {
            log('Back up Failed something went wrong');
           // CustomSnackBar(message: "Failed to verify, Please Check your internet connection", isSuccess: true).show();
          }
        } else {
           delIndex = phVerifBox.values.toList().indexWhere((element) => element.benfID == phVerif.benfID!);
          if (delIndex != -1) {
            phVerifBox.deleteAt(delIndex);
          }
          
          op.paginatedRefresh();
          //  op.fetchPaginatedBenfData(distID: phVerif.distID!, upazilaID: phVerif.upazillaID!, isSearch: false, statusID: 1, local: this);
        }
      }
    }
  }

  storeDlcQuesAns(LocalDlcQuesAns localdlcQ) {
    if (dlcQABox.values.toList().isEmpty) {
      dlcQABox.add(localdlcQ);
    } else {
      if (dlcQABox.values.toList().any((element) => element.id == localdlcQ.id)) {
        return;
      } else {
        dlcQABox.add(localdlcQ);
      }
    }
  }

  // updateDataForPhysicalVerificatiojn(
  //     {required String latitude, required String longitude, required int benfID, required String status, String? reason}) {
  //   PhysicalVerifyModelHive phvmodel = PhysicalVerifyModelHive()
  //     ..benfID = benfID
  //     ..latitude = latitude
  //     ..longitude = longitude
  //     ..status = status
  //     ..reason = reason;
  //   phVerifBox.add(phvmodel);
  //   notifyListeners();
  // }
}
