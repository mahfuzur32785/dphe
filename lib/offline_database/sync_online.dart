import 'dart:convert';

import 'package:dphe/api/le_dashboard_api/le_dashboard_api.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/offline_database/db_tables/le_tables/le_qsn_ans_table.dart';
import 'package:flutter/cupertino.dart';
import '../Data/models/hiveDbModel/dlc_ph_verify_model.dart';
import 'db_tables/le_tables/beneficiary_list_table.dart';
import 'package:hive/hive.dart';

class SyncOnlineProvider extends ChangeNotifier {
  /// LE data sync
  bool isDataSynchronizingLe = false;

  bool isBackupEnabled = false;

  Future<void> isDataSync() async {
    final beneficiaries = await BeneficiaryListTable().fetchAllBeneficiaries([1]);
    final qsnAnsList = await LeQsnAnsTable().fetchNotSyncAnsList();
    if (beneficiaries.isEmpty && qsnAnsList.isEmpty) {
      isBackupEnabled = false;
    } else {
      isBackupEnabled = true;
    }
    notifyListeners();
  }

  void leDashboardDataSync() async {
    isDataSynchronizingLe = true;

    notifyListeners();

    // Beneficiary booking data sync
    final beneficiaries = await BeneficiaryListTable().fetchAllBeneficiaries([1]); // getting data from offline
    if (beneficiaries.isNotEmpty) {
      for (int i = 0; i < beneficiaries.length; i++) {
        print("calling $i");
        print(beneficiaries[i].id);
        final responseString = await LeDashboardApi().selectBeneficiary(beneficiaryId: beneficiaries[i].id!); // posting data to online
        if (responseString == "200") {
          await BeneficiaryListTable().deleteSyncedBenf(beneficiaries[i].id!);
          isBackupEnabled = false;
        } else if (responseString == "300") {
          CustomSnackBar(message: 'Already Selected', isSuccess: false).show();
          await BeneficiaryListTable().deleteSyncedBenf(beneficiaries[i].id!);
          isBackupEnabled = false;
        } else {
          isBackupEnabled = true;
        }
      }
    }

    // Beneficiary booking data sync
    final qsnAnsList = await LeQsnAnsTable().fetchNotSyncAnsList(); // getting data from offline
    if (qsnAnsList.isNotEmpty) {
      for (int i = 0; i < qsnAnsList.length; i++) {
        print("calling $i");
        print(qsnAnsList[i].beneficiaryId);
        final res = await LeDashboardApi().newLeQuestionAnswerSubmit(
          beneficiaryId: qsnAnsList[i].beneficiaryId!,
          jsonAnswer: qsnAnsList[i].jsonAns ?? "",
          lat: qsnAnsList[i].lat ?? "",
          long: qsnAnsList[i].long ?? "",
          image: qsnAnsList[i].image ?? "",
        );
        
        if (res == "200") {
          isBackupEnabled = false;
          await LeQsnAnsTable().updateQsnAns(beneficiaryId: qsnAnsList[i].beneficiaryId!, isSync: 1);
        } else {
          isBackupEnabled = true;
        }
      }
    }

    isDataSynchronizingLe = false;
    notifyListeners();
  }
}
