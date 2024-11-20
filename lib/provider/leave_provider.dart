import 'dart:convert';
import 'dart:developer';
import 'package:dphe/Data/models/common_models/dlc_model/attendance_details_model.dart';
import 'package:dphe/Data/models/common_models/dlc_model/exen_data.dart';

import 'package:dphe/api/attendance_leave_api/attendance_leave_api.dart';
import 'package:dphe/api/auth_api/auth_api.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../Data/models/common_models/dlc_model/leave_details_model.dart';
import '../Data/models/common_models/dlc_model/lv_response_model.dart';
import '../helper/date_converter.dart';

class LeaveProvider extends ChangeNotifier {
  List<ExenData> _exenDataList = [];
  List<ExenData> get exenDataList => _exenDataList;

  bool isdiagLoading = false;

  Future<LeaveResponseMessageModel?> giveAttendance(
      {required OperationProvider op, required BuildContext context, bool isCOnfirmation = false}) async {
    LeaveResponseMessageModel? leaveResponseMessageModel;
    final postion = await op.getUsersPosition();
    if (postion != null) {
      leaveResponseMessageModel =
          await AttendanceLeaveApi().giveAttendance(latitude: postion.latitude, longitude: postion.longitude, isCOnfirmation: isCOnfirmation);
      if (leaveResponseMessageModel != null) {
        return leaveResponseMessageModel;
      } else {
        CustomSnackBar(isSuccess: false, message: 'Failed to get Data').show();
        //if (context.mounted) AuthApi().callLogoutApi(context: context);
      }

      notifyListeners();
    } else {
      Geolocator.openLocationSettings();
    }
    return leaveResponseMessageModel;
  }

  List<String> _lvCondDates = [];
  List<String> getLvCondDates(dynamic date) {
    List<String> tmpDate = [];
    if (date is String) {
      tmpDate.add(date);
    } else {
      tmpDate.addAll(date);
    }

    return tmpDate;
  }

  setDiagLoading({bool isLoading = false}) {
    if (isLoading) {
      isdiagLoading = true;
    } else {
      isdiagLoading = false;
    }
    notifyListeners();
  }

  List<AttendanceData> _attendanceDataList = [];
  List<AttendanceData> get attendanceDataList => _attendanceDataList;

  bool isAttDataLoading = false;

  Future<void> getUserAllAttendance(BuildContext context) async {
    _attendanceDataList = [];
    isAttDataLoading = true;
    AttendanceDetailsModel? attDetModel;
    final response = await AttendanceLeaveApi().getUserAttendance(context: context);
    if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
      var str = await response.stream.bytesToString();
      final json = jsonDecode(str);
      attDetModel = AttendanceDetailsModel.fromJson(json);
      _attendanceDataList = attDetModel.data!;

      //attDetModel = AttendanceDetailsModel.fromJson(json);
      isAttDataLoading = false;
    } else {
      isAttDataLoading = false;
      CustomSnackBar(isSuccess: false, message: 'Failed to fetch data from internet');
    }
    notifyListeners();
  }

  Future<void> getExenForLeave(BuildContext context) async {
    _exenDataList = [];
    final exenDataresponse = await AttendanceLeaveApi().getExenDataForLeave(context: context);
    if (exenDataresponse != null) {
      _exenDataList = exenDataresponse.data!;
    } else {
      _exenDataList = [];
    }

    notifyListeners();
  }

  List<LeaveData> _leaveDataList = [];
  List<LeaveData> get leaveDataList => _leaveDataList;

  Future<void> getAllLeaveData({bool isFilter = false, String? formDate, String? toDate}) async {
    LeaveDetailsModel? leaveResponse;
    _leaveDataList = [];
    if (isFilter) {
      leaveResponse = await AttendanceLeaveApi().getFilterLeaveData(isFilter: isFilter, formDate: formDate, toDate: toDate);
    } else {
      leaveResponse = await AttendanceLeaveApi().getAllLeaveData();
    }

    if (leaveResponse != null) {
      _leaveDataList = leaveResponse.data!;
      //notifyListeners();
    }
    notifyListeners();
  }

  bool isAttendanceBtnEnable = false;
  //
  getAttendance(BuildContext context) async {
     isAttendanceBtnEnable = false;
    // isloading = true;
    await getUserAllAttendance(context);
    //final isRealTime = await timeComparison();
    //if (isRealTime) {
      if (attendanceDataList.isNotEmpty) {
        if (attendanceDataList
            .any((element) => DateConverter.formatDateIOS(element.checkIn!) == DateConverter.localDateToIsoString(DateTime.now()))) {
          //setState(() {
          isAttendanceBtnEnable = false;
          //  isloading = false;
          //  });
        } else {
          // setState(() {
          isAttendanceBtnEnable = true;
          // isloading = false;
          //  });
        }
      } else {
        //   setState(() {
        isAttendanceBtnEnable = true;
        // isloading = false;
        //  });
      }
    // } else {
    //   isAttendanceBtnEnable = false;
    //   //  isloading = false;
    // }
    
    notifyListeners();
  }

  Future<LeaveResponseMessageModel?> leaveRequest(
      {int? exenId,
      // required String title,
      required String leaveType,
      required String fromDate,
      required String toDate,
      required String? description,
      int? leaveID}) async {
    LeaveResponseMessageModel? response;
    String responsMessage = '';
    response = await AttendanceLeaveApi().leaveApplication(
      exenId: exenId,
      leaveType: leaveType,
      fromDate: fromDate,
      toDate: toDate,
      description: description,
    );
    if (response != null) {
      return response;
    } else {
      response = null;
    }
    // if (response == "Error") {
    //   responsMessage = "Error";
    // } else if (response == '409') {
    //   responsMessage = '409';
    // } else {
    //   responsMessage = response;
    // }
    return response;
  }

  Future<LeaveResponseMessageModel?> updateLeave(
      {required String leaveType,
      required String fromDate,
      required String toDate,
      required String? description,
      required int exenID,
      int? leaveID,
      required BuildContext context}) async {
    LeaveResponseMessageModel? leaveResponseMessageModel;
    String responsMessage = '';
    leaveResponseMessageModel = await AttendanceLeaveApi()
        .updateLeaveAplication(leaveID: leaveID!, leaveType: leaveType, fromDate: fromDate, toDate: toDate, description: description, exenId: exenID);
    if (leaveResponseMessageModel != null) {
      return leaveResponseMessageModel;
    } else {
      CustomSnackBar(message: 'Operation Failed', isSuccess: false).show();
      // if (context.mounted) AuthApi().callLogoutApi(context: context);
    }

    return leaveResponseMessageModel;
  }

  Future<String> deleteLeaveRequest({required int leaveID}) async {
    String responsMessage = '';
    final response = await AttendanceLeaveApi().deleteLeave(leaveID: leaveID);
    if (response == "Error") {
      responsMessage = "Error";
    } else if (response == '409') {
      responsMessage = '409';
    } else {
      responsMessage = response;
    }
    return responsMessage;
  }

  int? _selectedExenID;
  int? get selectedExenID => _selectedExenID;
  String? _exenName;
  String? get exenName => _exenName;
  String? _selectedLeaveType;
  String? get selectedLeaveType => _selectedLeaveType;

  String _lvdescription = '';
  String get lvdescription => _lvdescription;

  int? _leaveID;
  int? get leaveID => _leaveID;

  setLeaveType({required String value}) {
    _selectedLeaveType = null;
    _selectedLeaveType = value;
    notifyListeners();
  }

  setExenID({required int value}) {
    _selectedExenID = null;
    _selectedExenID = value;
    notifyListeners();
  }

  setExenName({required String value}) {
    _exenName = null;
    _exenName = value;
    notifyListeners();
  }

  setRemarksControllerText({required TextEditingController rmrkController}) {}

  updateLeaveRequestData({
    required int exnID,
    required String exnName,
    required String fromDate,
    required String selectedLeaveType,
    required String toDate,
    required int leaveID,
    //required String? rmrkController,
    required String remarks,
  }) {
    _selectedExenID = exnID;
    _exenName = exnName;
    _leaveID = leaveID;
    _selectedLeaveType = selectedLeaveType;
    forapiFromDate = fromDate;
    forapiTodate = toDate;
    _lvdescription = remarks;
    //rmrkController = remarks;
    notifyListeners();
  }

  clearAllData({required TextEditingController rmrkController}) {
    _selectedExenID = null;
    _leaveID = null;
    _selectedLeaveType = null;
    _exenName = null;
    _selectedExenID = null;
    forapiFromDate = null;
    forapiTodate = null;
    _fromDateTemp = null;
    _toDateTemp = null;
    rmrkController.text = '';
    _lvdescription = '';
    notifyListeners();
  }

  DateTime currentDate = DateTime.now();
  String? leaveFromDate;
  String? toDate;
//  String leaveFromDate = DateConverter.dateFormatStyle2(DateTime.now());
  String fromDate = DateConverter.dateFormatStyle2(DateTime.now().subtract(Duration(days: 31)));
  //String toDate = DateConverter.dateFormatStyle2(DateTime.now());
  // String? _fromDateTemp ;
  String? _fromDateTemp;

  String? _toDateTemp;

  String? fromDateHistry;

  String? toDateHistry;

  // String _fromDateTemp =
  //     DateConverter.dateFormatStyle2(DateTime.now().add(Duration(days: 365)));
  // String _toDateTemp =
  //     DateConverter.dateFormatStyle2(DateTime.now().add(Duration(days: 365)));
  //String? _toDateTemp;
  DateTime? toDateTime;
  DateTime? fromDateTime;
  DateTime? currentDateTime;
  String? forapiFromDate;
  String? forapiTodate;

  //for leave history
  String _fromDateTempflvhist = DateConverter.dateFormatStyle2(DateTime.now().subtract(Duration(days: 365)));
  String _toDateTempflvhist = DateConverter.dateFormatStyle2(DateTime.now());

  clearHistoryDates() {
    fromDateHistry = null;
    toDateHistry = null;
    _fromDateTempflvhist = DateConverter.dateFormatStyle2(DateTime.now().subtract(Duration(days: 365)));
    _toDateTempflvhist = DateConverter.dateFormatStyle2(DateTime.now());
    notifyListeners();
  }

  updateDates(DateTime dateTime, {bool isFromDate = false}) {
    if (_fromDateTemp == null || _toDateTemp == null) {
      _fromDateTemp = forapiFromDate == null
          ? DateConverter.dateFormatStyle2(DateTime.now().subtract(Duration(days: 70)))
          : DateConverter.dateFormatFromAPi(forapiFromDate!);
      _toDateTemp = forapiTodate == null
          ? DateConverter.dateFormatStyle2(DateTime.now().add(Duration(days: 730)))
          : DateConverter.dateFormatFromAPi(forapiTodate!);
    }

    if (isFromDate) {
      _fromDateTemp = DateConverter.dateFormatStyle2(dateTime);
    } else {
      _toDateTemp = DateConverter.dateFormatStyle2(dateTime);
    }

    notifyListeners();
  }

  forHistoryUpdateDates(DateTime dateTime, {bool isFromDate = false}) {
    if (isFromDate) {
      _fromDateTempflvhist = DateConverter.dateFormatStyle2(dateTime);
    } else {
      _toDateTempflvhist = DateConverter.dateFormatStyle2(dateTime);
    }
  }

  onSavedDates(BuildContext context, {bool isFromDate = false}) {
    DateTime fromD = DateConverter.convertStringToDateFormat2(_fromDateTemp!);
    DateTime toD = DateConverter.convertStringToDateFormat2(_toDateTemp!);
    if (isFromDate) {
      if (fromD.isBefore(toD) || fromD == toD) {
        forapiFromDate = _fromDateTemp;
        // leaveFromDate = _fromDateTemp;
        DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
        DateTime inputDate = inputFormat.parse(forapiFromDate!);
        DateFormat outputFormat = DateFormat("yyyy-MM-dd");
        forapiFromDate = outputFormat.format(inputDate);
      } else {
        CustomSnackBar(message: 'From Date Should before or equal for To Date', isSuccess: false).show();
      }
    } else {
      if (toD.isAfter(fromD) || fromD == toD) {
        forapiTodate = _toDateTemp;
        // toDate = _toDateTemp;
        DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
        DateTime inputDate = inputFormat.parse(forapiTodate!);
        DateFormat outputFormat = DateFormat("yyyy-MM-dd");
        forapiTodate = outputFormat.format(inputDate);
      } else {
        CustomSnackBar(message: 'To Date Should After or equal for From Date', isSuccess: false).show();
      }
    }
    notifyListeners();
  }

  onlvHistrypdateDate(BuildContext context, {bool isFromDate = false}) {
    DateTime fromD = DateConverter.convertStringToDateFormat2(_fromDateTempflvhist);
    DateTime toD = DateConverter.convertStringToDateFormat2(_toDateTempflvhist);
    if (isFromDate) {
      if (fromD.isBefore(toD) || fromD == toD) {
        fromDateHistry = _fromDateTempflvhist;
        // leaveFromDate = _fromDateTemp;
        DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
        DateTime inputDate = inputFormat.parse(fromDateHistry!);
        DateFormat outputFormat = DateFormat("yyyy-MM-dd");
        fromDateHistry = outputFormat.format(inputDate);
      } else {
        CustomSnackBar(message: 'From Date Should before or equal for To Date', isSuccess: false).show();
      }
    } else {
      if (toD.isAfter(fromD) || fromD == toD) {
        toDateHistry = _toDateTempflvhist;
        // toDate = _toDateTemp;
        DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
        DateTime inputDate = inputFormat.parse(toDateHistry!);
        DateFormat outputFormat = DateFormat("yyyy-MM-dd");
        toDateHistry = outputFormat.format(inputDate);
      } else {
        CustomSnackBar(message: 'To Date Should After or equal for From Date', isSuccess: false).show();
      }
    }
    notifyListeners();
  }

  leaveOperation() async {
    //await getAllLeaveData(isFilter: false);
    var lvaf = leaveDataList
        .firstWhere((lvd) => DateConverter.lvLogicDate(lvd.fromDate!).day == (DateConverter.lvLogicDate(forapiFromDate!)).day,
            orElse: () => LeaveData(id: null, fromDate: null))
        .fromDate;
    var lvtd = leaveDataList
        .firstWhere(
          (lvd) => DateConverter.lvLogicDate(lvd.toDate!).day == (DateConverter.lvLogicDate(forapiTodate!)).day,
          orElse: () => LeaveData(id: null, toDate: null),
        )
        .toDate;

    if (lvaf != null && lvtd != null) {
      forapiFromDate = null;
      forapiTodate = null;
      _fromDateTemp = null;
      _toDateTemp = null;
      notifyListeners();
      CustomSnackBar(isSuccess: false, message: 'You cant select this date because it Already applied please select edit button').show();
    } else {
      var isExistingDate = leaveDataList.any((lv) {
        return (DateConverter.lvLogicDate(forapiFromDate!).isAfter(DateConverter.lvLogicDate(lv.fromDate!))) &&
            (DateConverter.lvLogicDate(forapiTodate!).isBefore(DateConverter.lvLogicDate(lv.toDate!)));
      });
      if (isExistingDate) {
        forapiFromDate = null;
        forapiTodate = null;
        _fromDateTemp = null;
        _toDateTemp = null;
        notifyListeners();
        CustomSnackBar(isSuccess: false, message: 'You cant select this date').show();
      } else {
        return;
        //CustomSnackBar(isSuccess: true, message: 'You can select this date').show();
      }

      //return;
    }
    // var isExistingDate = leaveDataList.any((lv) {
    //   return (DateConverter.lvLogicDate(forapiFromDate!).isAfter(DateConverter.lvLogicDate(lv.fromDate!)) ||
    //           DateConverter.lvLogicDate(lv.fromDate!).day == (DateConverter.lvLogicDate(forapiFromDate!)).day) &&
    //       (DateConverter.lvLogicDate(forapiTodate!).isBefore(DateConverter.lvLogicDate(lv.toDate!)) ||
    //           DateConverter.lvLogicDate(lv.toDate!).day == (DateConverter.lvLogicDate(forapiTodate!)).day);
    // });
    //var s = isExistingDate;

    //   if (isExistingDate) {
    //     forapiFromDate = null;
    //     forapiTodate = null;
    //     _fromDateTemp = null;
    //     _toDateTemp = null;
    //     notifyListeners();
    //   CustomSnackBar(isSuccess: false,message: 'You cant select this date').show();
    // } else {
    //    CustomSnackBar(isSuccess: true,message: 'You can select this date').show();
    // }
  }

  Future<bool> timeComparison() async {
    final actualTimeData = await AttendanceLeaveApi().getActualTime();
    if (actualTimeData != null) {
      final actualDateTime = DateConverter.formatDateIOS(actualTimeData.datetime!);
      log('actual dataTime$actualDateTime');
      final localDTime = DateConverter.localDateToIsoString(DateTime.now());
      if (actualDateTime == localDTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  final List<LeaveTypeModel> _leaveTypeList = [
    LeaveTypeModel(id: 1, leaveTypeName: "Casual leave"),
    LeaveTypeModel(id: 2, leaveTypeName: "Sick leave"),
    LeaveTypeModel(id: 3, leaveTypeName: "Emergency leave"),
    LeaveTypeModel(id: 4, leaveTypeName: "Annual leave"),
    LeaveTypeModel(id: 5, leaveTypeName: "Maternity leave"),
    LeaveTypeModel(id: 6, leaveTypeName: "paternity leave"),
    LeaveTypeModel(id: 7, leaveTypeName: "Special leave"),
    LeaveTypeModel(id: 8, leaveTypeName: "Other leave"),
  ];

  List<LeaveTypeModel> get leaveTypeList => _leaveTypeList;
}

class LeaveTypeModel {
  final int? id;
  final String? leaveTypeName;

  LeaveTypeModel({this.id, this.leaveTypeName});
}
