import 'dart:convert';

import 'package:dphe/Data/models/common_models/dlc_model/dlc_assignment_model.dart';
import 'package:dphe/Data/models/common_models/dlc_model/package_data_model.dart';
import 'package:dphe/api/beneficiary_api/dlc_api/dlc_report_api.dart';
import 'package:dphe/api/dlc_other_activity_api/other_activity_api.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';

import '../Data/models/common_models/dlc_model/package_scheme_model.dart';
import '../Data/models/common_models/dlc_model/progress_item_model.dart';
import '../components/custom_snackbar/custom_snakcbar.dart';

class DlcActivityReportProvider extends ChangeNotifier {
  bool isOActLoading = false;

  List<DlcActivityData> _dlcActivityData = [];
  List<DlcActivityData> get dlcActivityData => _dlcActivityData;
  Future<void> getDlcOtherActivityAssignmentList() async {
    _dlcActivityData = [];
    //_attendanceDataList = [];
    isOActLoading = true;
    DlcAssignmentModel? dlcAssignmentModel;
    final response = await OtherActivityApi().getAllAssignments();
    if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
      var str = await response.stream.bytesToString();
      final json = jsonDecode(str);
      dlcAssignmentModel = DlcAssignmentModel.fromJson(json);
      _dlcActivityData = dlcAssignmentModel.data!;
      _dlcActivityData = dlcActivityData.where((element) => element.type == 'bcc').toList();

      //attDetModel = AttendanceDetailsModel.fromJson(json);
      isOActLoading = false;
      notifyListeners();
    } else {
      isOActLoading = false;
      CustomSnackBar(isSuccess: false, message: 'Failed to fetch data from internet');
    }
  }

  List<PData> _packageDataList = [];
  List<PData> get packageDataList => _packageDataList;

   List<PackageSchemeModel> _schemeDataList = [];
  List<PackageSchemeModel> get schemeDataList => _schemeDataList;

    List<ProgressItem> _progressItemList = [];
  List<ProgressItem> get progressItemList => _progressItemList;

  List<CheckProgressItemModel>_chProgressItemQuesList = [];
  List<CheckProgressItemModel> get chProgressItemQuesList => _chProgressItemQuesList ;

  Future<void> getPackageInfoProvider() async {
    _packageDataList =[];
    PackageDataModel? packageDataModel;
    packageDataModel = await DlcReportApi().getPackageData();
    if (packageDataModel != null) {
      _packageDataList = packageDataModel.data!;
    }
    notifyListeners();
  }

  Future<void> getSchemeData({required int id}) async {
    _schemeDataList =[];
    PackageDataModel? packageDataModel;
   final schemeList = await DlcReportApi().getSchemeData(id: id);
    if (schemeList != null) {
      _schemeDataList = schemeList;
    }
    notifyListeners();
  }

    Future<void> getProgressItem({required int schemeData}) async {
    _progressItemList =[];
    _chProgressItemQuesList = [];
    PackageDataModel? packageDataModel;
   final progList = await DlcReportApi().getProgressItemData(schemeTypeID: schemeData);
    if (progList != null) {
    _progressItemList = progList.data!;
    if (progressItemList.isNotEmpty) {
      for (var element in progressItemList) {
        _chProgressItemQuesList.add(CheckProgressItemModel(progItem: element, value: null));
      }
    } else {
      //dev.log('failed');
    }
    }
    notifyListeners();
  }



  updateProgItemQuestion({required int value, required int index}) {
    _chProgressItemQuesList[index].value = value;
   // dev.log('Answer Data $value');
    //  dev.log('Answer list ${jsonEncode(chDlcQuestion)}');
    notifyListeners();
  }

  // getAllLeScreeningAnswer() {
  //   List<DlcQAnsModel> temp = [];
  //   _getLEAnswer = [];
  //   //var t = chDlcQuestion.map((e) => null)
  //   for (var element in chLEQuestion) {
  //     _getLEAnswer.add(DlcQAnsModel(
  //       questionId: element.dlcQ.id,
  //       answer: element.value.toString(),
  //     ));
  //   }
  //   dev.log('answer data ${jsonEncode(getLEAnswer)}');
  //   notifyListeners();
  // }




  String? _errorText;
  String? get errorText => _errorText;

  setErrorText({String? value}) {
    if (value != null) {
      _errorText = null;
      notifyListeners();
    } else {
      _errorText = 'Field value must not be Empty';
      notifyListeners();
    }
    notifyListeners();
  }

  final List<CustomTabModel> _dlcOtherActivityList = [
    CustomTabModel(id: 1, title: 'Participate in Upazila WatSan Committee orientation'),
    CustomTabModel(id: 2, title: 'Participate in Up Training'),
    CustomTabModel(id: 3, title: 'Participate in LE orientation'),
    CustomTabModel(id: 4, title: 'Participate in BCC session with Community people at Ward Level'),
    CustomTabModel(id: 5, title: 'Participate in Union Level coordination meeting with stakeholders (Health,PKSF,UP,LE)')
  ];
  List<CustomTabModel> get dlcOtherActivityList => _dlcOtherActivityList;

  final List<CustomTabModel> _otherActivityTypeList = [
    CustomTabModel(id: 1, title: 'Orientation'),
    CustomTabModel(id: 2, title: 'Capacity building Training'),
    CustomTabModel(id: 3, title: 'Meeting'),
  ];
  List<CustomTabModel> get otherActivityTypeList => _otherActivityTypeList;

  final List<CustomTabModel> _dlcReportTypeList = [
    CustomTabModel(id: 1, title: 'Twin Pit Latrine'),
    CustomTabModel(id: 2, title: 'Public Sanitation and Hygiene'),
    CustomTabModel(id: 3, title: 'Response to COVID-19 Hand Washing Station with Running Water'),
    CustomTabModel(id: 4, title: 'New Sanitation and Hygience Facilities in Community Clinics'),
    CustomTabModel(id: 5, title: 'Provision for Running Water and Associated Facilities in Toilets of Community Clinics'),
    CustomTabModel(id: 6, title: 'Community-Based Small Piped Water Supply Schemes'),
    CustomTabModel(id: 7, title: 'Large Piped Water Supply Schemes')
  ];
  List<CustomTabModel> get dlcReportingList => _dlcReportTypeList;
}


class CheckProgressItemModel {
  final ProgressItem progItem;
  int? value;

  CheckProgressItemModel({required this.progItem, this.value});
}