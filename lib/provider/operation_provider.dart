import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:dphe/Data/models/common_models/camera_model.dart';
import 'package:dphe/Data/models/common_models/district_model.dart';
import 'package:dphe/Data/models/hiveDbModel/dlc_que_ans.dart';
import 'package:dphe/components/camera_widget/camera_capture.dart';
import 'package:dphe/offline_database/db_tables/union_table.dart';
import 'package:dphe/screens/users/dlc/dlc_report_progression/dlc_report_list.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:html/dom.dart';
import 'package:upgrader/upgrader.dart';
import 'package:dphe/Data/models/common_models/dlc_model/send_back_model.dart';
import 'package:dphe/Data/models/hiveDbModel/dlc_ph_verify_model.dart';
import 'package:dphe/Data/models/hiveDbModel/upazilla_hive_model.dart';
import 'package:dphe/api/auth_api/auth_api.dart';
import 'package:dphe/pusher_services.dart';
import 'package:dphe/screens/users/dlc/leave_request/leave_history_page.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:dartx/dartx.dart';
import 'package:version/version.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dphe/Data/models/auth_models/new_user_data_model.dart';
import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/Data/models/common_models/union_dropdown_model.dart';
import 'package:dphe/api/beneficiary_api/dlc_api/beneficiary_api.dart';
import 'package:dphe/api/le_dashboard_api/le_dashboard_api.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/provider/hive_provider.dart';
import 'package:dphe/screens/users/dlc/twin_pit_district_page.dart';
import 'package:dphe/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../Data/models/common_models/dlc_model/dlc_question_model.dart';
import '../Data/models/common_models/dlc_model/le_data_model.dart';
import '../Data/models/common_models/upazila_dropdown_model.dart';
import '../Data/models/le_models/le_answer_mode.dart';
import '../api/beneficiary_api/dlc_api/dlc_twin_pit_latrine_verification_api.dart';
import '../api/beneficiary_api/dlc_api/hcp_hhs_frwrd_api.dart';
import '../offline_database/sync_online.dart';
import '../screens/users/dlc/attendance/attendance_screen.dart';
import '../screens/users/dlc/dlc_dashboard/dlc_twin_pit_dshbrd.dart';
import '../screens/users/dlc/dlc_twin_pit_latrine_page.dart';
import '../screens/users/dlc/leave_request/leave_request.dart';
import '../utils/api_constant.dart';
import '../utils/app_colors.dart';
import '../utils/local_storage_manager.dart';

class OperationProvider extends ChangeNotifier {
  bool isPasswordVisible = true;

  setPasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  String? errorOnPassword;
  String? successOnPassword;

  Future<bool> changePassword({
    required String currentPass,
    required String newPass,
    required String passwordConfirmation,
  }) async {
    errorOnPassword = null;
    successOnPassword = null;
    bool isPop = false;
    var chngPassRes = await AuthApi().changePassword(currentPass: currentPass, newPass: newPass, passwordConfirmation: passwordConfirmation);
    if (chngPassRes != null) {
      if (chngPassRes.statusCode == 200) {
        successOnPassword = chngPassRes.changePassMessage;
        isPop = true;
      } else {
        successOnPassword = chngPassRes.changePassMessage;
        isPop = false;
      }
    } else {
      successOnPassword = 'error';
    }
    notifyListeners();
    return isPop;
  }

  List<dynamic> _allUserPermission = [];
  List<dynamic> get allUserPermission => _allUserPermission;

  List<dynamic> _filteredPermission = [];
  List<dynamic> get filteredPermission => _filteredPermission;

  List<Districts> _districtsList = [];
  List<Districts> get districtsList => _districtsList;

  List<Upazilas> _leUpazillaList = [];
  List<Upazilas> get leUpazillaList => _leUpazillaList;

  List<DropdownUpazila> _upazilaList = [];
  List<DropdownUpazila> get upazilaList => _upazilaList;

  List<Upazilas> _tempupazilasList = [];
  List<Upazilas> get tempupazilasList => _tempupazilasList;

  int _statusID = 11;
  int get statusID => _statusID;

  int? _isSendBack;
  int? get isSendBack => _isSendBack;

  List<DropdownUnion> _unionList = [];
  List<DropdownUnion> get unionList => _unionList;

  List<DropdownUnion> _tempunionList = [];
  List<DropdownUnion> get tempunionList => _tempunionList;
  bool _isSearching = false;

  bool get isSearching => _isSearching;

  selectDlcStatusID({required int value}) {
    _statusID = value;
    notifyListeners();
  }
  changeIsSendBackSts({ int? value}){
    if (value != null) {
       _isSendBack=value;
    }else{
      _isSendBack = null;
    }
   
    notifyListeners();
  }

  void startSearching() {
    _isSearching = true;
    notifyListeners();
  }

  void stopSearching() {
    _isSearching = false;
    notifyListeners();
  }

  Future<void> getUnionListFromApi({required int upazillaID, bool isOtherActivity = false}) async {
    _unionList = [];
    if (isConnected) {
      final union = await LeDashboardApi().getUnionDropdownApi(upazilaId: upazillaID);
      dev.log('union $union');
      if (union != null) {
        _unionList = union.data!.union!;
        _tempunionList = unionList;

        if (isOtherActivity) {
          return;
        } else {
          _unionList.insert(
              0,
              DropdownUnion(
                id: 0,
                bnName: AppConstant.allUnion,
              ));

          for (var element in unionList) {
            await UnionTable().insertUnionSql(id: element.id!, bnName: element.bnName!, name: element.name ?? '', upaID: element.upazilaId);
          }
        }

        // _unionList.add();
      } else {
        //_unionList = await UnionTable().fetchUnion(upazillaId: upazillaID);
        _unionList = [];
      }
    } else {
      _unionList = await UnionTable().fetchUnion(upazillaId: upazillaID);
    }

    notifyListeners();
  }

  searchUnion(String query) {
    if (query.isEmpty) {
      unionList.clear();
      _unionList = tempunionList;
      notifyListeners();
    } else {
      _unionList = [];
      for (var element in tempunionList) {
        if (element.name != null && element.name!.toLowerCase().contains(query.toLowerCase())) {
          _unionList.add(element);
        }
      }
    }

    notifyListeners();
  }

  Future<void> getDistrictListFromUser() async {
    final String districtsData = await LocalStorageManager.readData(AppConstant.districts) ?? '';
    if (districtsData.isNotEmpty) {
      final List<dynamic> distr = jsonDecode(districtsData);
      dev.log('dist data $distr');
      _districtsList = distr.map((e) => Districts.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> getUpazillasFromUser() async {
    final String upazillaData = await LocalStorageManager.readData(AppConstant.upazillas) ?? '';
    if (upazillaData.isNotEmpty) {
      final List<dynamic> upaz = jsonDecode(upazillaData);
      dev.log('dist data $upaz');
      _leUpazillaList = upaz.map((e) => Upazilas.fromJson(e)).toList();

      _leUpazillaList.insert(
        0,
        Upazilas(
          id: 0,
          bnName: AppConstant.allUpazila,
        ),
      );
      _tempupazilasList = leUpazillaList;
    }
    notifyListeners();
  }

  searchUpazillas(String query) {
    if (query.isEmpty) {
      leUpazillaList.clear();
      _leUpazillaList = tempupazilasList;
      notifyListeners();
    } else {
      _leUpazillaList = [];
      for (var element in tempupazilasList) {
        if (element.name != null && element.name!.toLowerCase().contains(query.toLowerCase())) {
          _leUpazillaList.add(element);
        }
      }
    }

    notifyListeners();
  }

  Future<geo.Position?>? getUsersPosition() async {
    geo.Position? position;
    try {
      position = await geo.Geolocator.getCurrentPosition(timeLimit: Duration(seconds: 30));
      dev.log('current lat ${position.latitude} ${position.longitude}');
      return position;
    } catch (e) {
      if (e is TimeoutException) {
        debugPrint('The Exception is E $e');
        position = null;

        return position;
      }
    }

    return position;
  }

  bool upazilaLoading = false;

  Future<void> getUpazila({required int districtID, LocalStoreHiveProvider? local}) async {
    _upazilaList = [];
    upazilaLoading = true;

    final upazilaData = await LeDashboardApi().getUpazillaDropdownApi(districtId: districtID);
    if (upazilaData != null) {
      _upazilaList = upazilaData.data!.upazila!;
      for (var element in upazilaList) {
        local!.storeUpazilla(upazilla: UpazillaHiveModel(id: element.id, name: element.name, districtID: element.districtId));
      }
    } else {
      _upazilaList = [];
    }

    upazilaLoading = false;
    notifyListeners();
    // log(jsonEncode(upazilaData));
  }

  List<BeneficiaryDetailsData?> _beneficiaryList = [];
  List<BeneficiaryDetailsData?> get beneficiaryList => _beneficiaryList;
  List<BeneficiaryDetailsData?> _tempBenficiaryList = [];
  List<BeneficiaryDetailsData?> get tempBenficiaryList => _tempBenficiaryList;

  List<BeneficiaryDetailsData?> _leWiseBeneficiaryList = [];
  List<BeneficiaryDetailsData?> get leWiseBeneficiaryList => _leWiseBeneficiaryList;

  List<StswiseLeData?> _leListForForward = [];
  List<StswiseLeData?> get leListForForward => _leListForForward;

  List<BeneficiaryDetailsData?> _dlcForwardList = [];
  List<BeneficiaryDetailsData?> get dlcForwardList => _dlcForwardList;
  List<BeneficiaryDetailsData?> _dlcsendBackList = [];
  List<BeneficiaryDetailsData?> get dlcsendBackList => _dlcsendBackList;

  List<BeneficiaryDetailsData?> _ltrPendingDlcBenfList = [];
  List<BeneficiaryDetailsData?> get ltrPendingDlcBenfList => _ltrPendingDlcBenfList;

  List<CheckBeneficiartModel> _chLeWiseBenfList = [];
  List<CheckBeneficiartModel> get chLeWiseBenfList => _chLeWiseBenfList;

  List<CheckBeneficiartModel> _tempchLeWiseBenfList = [];
  List<CheckBeneficiartModel> get tempchLeWiseBenfList => _tempchLeWiseBenfList;

  List<PhysicalVerifyModelHive> _localBenficiaryList = [];
  List<PhysicalVerifyModelHive> get localBenficiaryList => _localBenficiaryList;
  bool isBenficiaryLoading = false;

  bool fromLocalData = false;

  Future<void> getBeneficiaryList({
    required int distID,
    required int upazilaID,
    bool isSearch = false,
    String? phoneOrLe,
    required int statusID,
    int? unionId,
    int? wardNo,
    int? leid,
    bool isLeWiseBeneficiariesPage = false,
    bool isChooseHcpForward = false,
    bool isDlcSendback = false,
    bool isLatrInstlVerification = false,
    bool isSendBackltrvrf = false,
    LocalStoreHiveProvider? local,
  }) async {
    fromLocalData = false;
    _beneficiaryList = [];
    _ltrPendingDlcBenfList = [];
    //beneficiaryList.clear();
    //  if (local != null) {
    //   local.phVerifBox.clear();
    // }
    _dlcForwardList = [];
    if (isLatrInstlVerification) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          ltrPendingDlcBenfList.clear();
        },
      );

      notifyListeners();
    }
    // await Future.delayed(
    //   const Duration(milliseconds: 500),
    //   () {
    //     localBenficiaryList.clear();
    //   },
    // );

    _leWiseBeneficiaryList = [];
    BeneficiaryModel? getBenificiaryData = BeneficiaryModel();
    isBenficiaryLoading = true;
    notifyListeners();
    _beneficiaryList = [];

    if (!isLeWiseBeneficiariesPage) {
      getBenificiaryData = await BeneficiaryApi().getbeneficiaryList(
        districtID: distID,
        statusID: statusID,
        upazilaID: upazilaID,
        isLeWiseBeneficiaries: false,
        isSearch: isSearch,
        phoneOrLe: phoneOrLe,
        unionID: unionId,
        wardNo: wardNo,
        pageNO: 1,
      );

      if (getBenificiaryData != null) {
        if (local != null) {
          await Future.delayed(Duration(seconds: 2), () {
            return local.phVerifBox.clear();
          });
        }
        _localBenficiaryList = [];
        _beneficiaryList = getBenificiaryData.data ?? [];
        dev.log('dlc benf ${beneficiaryList.length}');
        // if (local != null) {
        //   storeDraftedDataInLocal(local: local);
        // }

        //  local!.phVerifBox.values.toList();
        //local!.phVerifBox.addAll();

        notifyListeners();

        //
      } else {
        fromLocalData = true;
        if (local != null) {
          getLocalPhverData(local: local, upaID: upazilaID);
        }
        // _localBenficiaryList =
        // notifyListeners();
      }
    } else if (isLeWiseBeneficiariesPage) {
      getBenificiaryData = isSearch
          ? await BeneficiaryApi().getbeneficiaryList(
              districtID: distID,
              upazilaID: upazilaID,
              isSearch: true,
              phoneOrLe: phoneOrLe,
              statusID: statusID,
              leid: leid,
              isLeWiseBeneficiaries: true)
          : await BeneficiaryApi().getbeneficiaryList(
              districtID: distID,
              upazilaID: upazilaID,
              isSearch: false,
              statusID: statusID,
              leid: leid,
              isLeWiseBeneficiaries: true,
            );
      if (isLatrInstlVerification) {
        _ltrPendingDlcBenfList = getBenificiaryData?.data ?? [];
      } else {
        chLeWiseBenfList.clear();
        // _leWiseBeneficiaryList = getBenificiaryData!.data!;
        if (isChooseHcpForward) {
          _dlcForwardList = getBenificiaryData?.data ?? [];
        } else {
          for (var element in getBenificiaryData!.data!) {
            // if (!chLeWiseBenfList
            //     .any((element) => element.benfData == element.benfData)) {
            _chLeWiseBenfList.add(CheckBeneficiartModel(benfData: element, isCheck: false));
            // }
          }
          _tempchLeWiseBenfList = chLeWiseBenfList;
        }
      }
    }

    isBenficiaryLoading = false;

    notifyListeners();
  }

  int _paginatedPageNo = 1;
  int get paginatedPageNo => _paginatedPageNo;
  bool isPaginatedLoading = false;
  bool hasMore = true;
  Future<void> fetchPaginatedBenfData(
      {required int distID,
      required int upazilaID,
      bool isSearch = false,
      String phoneOrLe = '',
      required int statusID,
      int? unionId,
      int? wardNo,
      int? leid,
      int? isSendBack,
      bool isLeWiseBeneficiariesPage = false,
      bool isChooseHcpForward = false,
      bool isLatrInstlVerification = false,
      bool isSendBackltrvrf = false,
      LocalStoreHiveProvider? local,
      bool isStartUp = true}) async {
    if (isPaginatedLoading) return;
    isPaginatedLoading = true;
    // if (!isConnected) {
    //   getLocalPhverData(local: local!, upaID: upazilaID, isStartUp: isStartUp);
    // } 
    //else {
      final getBenificiaryData = await BeneficiaryApi().fetchPaginatedBeneficiaryList(
        districtID: distID,
        statusID: statusID,
        upazilaID: upazilaID,
        isLeWiseBeneficiaries: false,
        isSearch: isSearch,
        isSendBack: isSendBack,
        phoneOrLe: phoneOrLe,
        leid: leid,
        unionID: unionId,
        wardNo: wardNo,
        pageNo: paginatedPageNo,
      );
      // if (getBenificiaryData ) {

      // }
      final fetchedbeneficiaryList = getBenificiaryData?.data ?? [];
      _paginatedPageNo++;
      isPaginatedLoading = false;
      if (fetchedbeneficiaryList.length < 4) {
        hasMore = false;
      }

      _beneficiaryList.addAll(fetchedbeneficiaryList);
      if (local != null) {
        if (statusID == 1) {
          //storeDraftedDataInLocal(local: local);
        } else {
          //return;
        }
        //  local.phVerifBox.clear();
      }
    //}

    if (isStartUp) {
      notifyListeners();
    }

    notifyListeners();
  }

  Future paginatedRefresh() async {
    isPaginatedLoading = false;
    // hasMore = false;
    hasMore = true;
    _paginatedPageNo = 1;
    beneficiaryList.clear();

    notifyListeners();
  }

  List<PhysicalVerifyModelHive> _tempLocalBenfList = [];
  List<PhysicalVerifyModelHive> get tempLocalBenfList => _tempLocalBenfList;

  getLocalPhverData({required LocalStoreHiveProvider local, required int upaID, bool isStartUp = true}) {
    beneficiaryList.clear();
    _localBenficiaryList = [];
    _localBenficiaryList = local.phVerifBox.values.toList().where((element) => element.isOnline == 'online' && element.upazillaID == upaID).toList();

    _tempLocalBenfList = localBenficiaryList;
    localBenficiaryList.forEach((localbenf) {
      _beneficiaryList.add(BeneficiaryDetailsData(
          id: localbenf.benfID,
          name: localbenf.benfName,
          nid: localbenf.benfNID,
          phone: localbenf.benfMobileNo,
          houseName: localbenf.benfHouse,
          districtId: localbenf.distID,
          upazilaId: localbenf.upazillaID,
          upazila: Upazila(name: localbenf.upazillaName),
          union: Union(name: localbenf.unionName),
          district: District(name: localbenf.districtName),
          wardNo: localbenf.wardno

          //union.name: localbenf.unionName,
          ));
    });
    _tempBenficiaryList = beneficiaryList;
    if (!isStartUp) {
      notifyListeners();
    }
  }

  storeDraftedDataInLocal({required LocalStoreHiveProvider local}) {
    var loclist = local.phVerifBox.values.toList();
    //local.phVerifBox.clear();

    for (var element in beneficiaryList) {
      var phvModel = PhysicalVerifyModelHive()
        ..id = element!.sl
        ..benfID = element!.id
        ..benfNID = element.nid.toString()
        ..wardno = element.wardNo
        ..benfName = element.name
        ..benfNID = element.nid
        ..districtName = element.district!.name
        ..benfMobileNo = element.phone
        ..distID = element.district!.id
        ..unionName = element.union?.name
        ..upazillaID = element.upazila!.id
        ..upazillaName = element.upazila?.name
        ..benfMobileNo = element.phone
        ..benfHouse = element.houseName
        ..status = '1'
        ..isOnline = 'online';
      if (!local.phVerifBox.values.toList().any((e) => e.benfID == element.id)) {
        dev.log('added in local store');
        local.phVerifBox.add(phvModel);
      }

      //local.storeDataForPhysicalVerificatiojn(phvmodel: phvModel);
    }
  }

  searchLeWiseBenfListData(String query) {
    if (query.isEmpty) {
      chLeWiseBenfList.clear();
      _chLeWiseBenfList = tempchLeWiseBenfList;
      notifyListeners();
    } else {
      _chLeWiseBenfList = [];
      for (var element in tempchLeWiseBenfList) {
        if ((element.benfData!.name != null && element.benfData!.name!.toLowerCase().contains(query.toLowerCase())) ||
            (element.benfData!.union!.name != null && element.benfData!.union!.name!.toLowerCase().contains(query.toLowerCase())) ||
            (element.benfData!.phone != null && element.benfData!.phone!.toLowerCase().contains(query.toLowerCase())) ||
            (element.benfData!.houseName != null && element.benfData!.houseName!.toLowerCase().contains(query.toLowerCase()))) {
          _chLeWiseBenfList.add(element);
        }
      }
    }

    notifyListeners();
  }

  searchBenfListData(String query) {
    if (query.isEmpty) {
      beneficiaryList.clear();
      _beneficiaryList = tempBenficiaryList;
      notifyListeners();
    } else {
      _beneficiaryList = [];
      for (var element in tempBenficiaryList) {
        if ((element!.name != null && element!.name!.toLowerCase().contains(query.toLowerCase())) ||
            (element.union!.name != null && element.union!.name!.toLowerCase().contains(query.toLowerCase())) ||
            (element.phone != null && element.phone!.toLowerCase().contains(query.toLowerCase())) ||
            (element.houseName != null && element.houseName!.toLowerCase().contains(query.toLowerCase()))) {
          _beneficiaryList.add(element);
        }
      }
    }

    notifyListeners();
  }

  searchLocalBenfData(String query) {
    if (query.isEmpty) {
      localBenficiaryList.clear();
      _localBenficiaryList = tempLocalBenfList;
      notifyListeners();
    } else {
      _localBenficiaryList = [];
      for (var element in tempLocalBenfList) {
        if ((element.benfName != null && element.benfName!.toLowerCase().contains(query.toLowerCase())) ||
            (element.unionName != null && element.unionName!.toLowerCase().contains(query.toLowerCase())) ||
            (element.benfPhone != null && element.benfPhone!.toLowerCase().contains(query.toLowerCase())) ||
            (element.benfHouse != null && element.benfHouse!.toLowerCase().contains(query.toLowerCase()))) {
          _localBenficiaryList.add(element);
        }
      }
    }

    notifyListeners();
  }

  retrieveLocalDataForPhverf({required LocalStoreHiveProvider local}) {
    localBenficiaryList.clear();
    _localBenficiaryList = local.phVerifBox.values.toList().where((element) => element.isOnline == 'online').toList();

    notifyListeners();
  }

  getSendBackLatr({
    required int distID,
    required int upazilaID,
    bool isSearch = false,
    String? phoneOrLe,
    required int statusID,
    int? leid,
  }) async {
    ltrPendingDlcBenfList.clear();
    isBenficiaryLoading = true;
    notifyListeners();
    BeneficiaryModel? getBenificiaryData = BeneficiaryModel();
    getBenificiaryData = await BeneficiaryApi().getSendBackLtrVerf(
      districtID: distID,
      upazilaID: upazilaID,
      isSearch: false,
      statusID: statusID,
      leid: leid,
    );
    if (getBenificiaryData != null) {
      _ltrPendingDlcBenfList = getBenificiaryData.data!;
    }
    isBenficiaryLoading = false;
    notifyListeners();
  }

  int initialLvtab = 0;

  setLatrinVerfTab({required int val}) {
    initialLvtab = val;
    notifyListeners();
  }

  // List<>

  selectAllBen({bool isDeselect = false}) {
    listOfSelectedForwarded.clear();
    if (!isDeselect) {
      chLeWiseBenfList.forEach((element) {
        element.isCheck = true;
        _listOfSelectedbenfIDForwarded.add(element.benfData!.id!);
      });
    } else {
      chLeWiseBenfList.forEach((element) {
        element.isCheck = false;
        _listOfSelectedbenfIDForwarded.remove(element.benfData!.id!);
      });
    }

    dev.log('all check ${jsonEncode(listOfSelectedForwarded)}');
    notifyListeners();
  }

//for hcp forward
  getStatusWiseLe({required int distID, required int upazilaID, bool isSearch = false, String? phoneOrLe, required int statusID}) async {
    isBenficiaryLoading = true;
    _leListForForward = [];
    final getstsWiseHouseHoldData = isSearch
        ? await HcpHssFrwrdApi().getstsWiseLEData(districtID: distID, upazilaID: upazilaID, isSearch: true, phoneOrLe: phoneOrLe, statusID: 7)
        : await HcpHssFrwrdApi().getstsWiseLEData(
            districtID: distID,
            upazilaID: upazilaID,
            isSearch: false,
            statusID: 7,
          );

    _leListForForward = getstsWiseHouseHoldData!.data!;
    isBenficiaryLoading = false;

    notifyListeners();
  }

  List<StswiseLeData?> _leListForLatrineVerification = [];
  List<StswiseLeData?> get leListForLatrineVerification => _leListForLatrineVerification;
  bool ltrVerfLoading = false;

  Future<void> getLeForLatrineVerification(
      {required int distID, required int upazilaID, bool isSearch = false, String? phoneOrLe, required int statusID}) async {
    ltrVerfLoading = true;
    _leListForLatrineVerification = [];
    final getLeflv = isSearch
        ? await HcpHssFrwrdApi().getstsWiseLEData(
            districtID: distID,
            upazilaID: upazilaID,
            isSearch: true,
            phoneOrLe: phoneOrLe,
            statusID: statusID,
          )
        : await HcpHssFrwrdApi().getstsWiseLEData(
            districtID: distID,
            upazilaID: upazilaID,
            isSearch: false,
            statusID: statusID,
          );
    if (getLeflv != null) {
      _leListForLatrineVerification = getLeflv!.data!;
    } else {
      _leListForLatrineVerification = [];
    }
    ltrVerfLoading = false;
    notifyListeners();
  }

  getPermissionWiseOptions() {
    var p = LocalStoreHiveProvider().getUserPermission();

    _allUserPermission = p;
    checkdlcLatrineMenuAccessPermission();
    //notifyListeners();
  }

  bool isVerificationLoading = false;

  Future<bool> physicalVerifyBeneficiary({
    required int id,
    required String status,
    String? reason,
    required String dlcQuestion,
    // required List<DlcQAnsModel> dlcQuestion,
    required String latitude,
    required String longitude,
  }) async {
    bool isVerifySuccess = false;
    isVerificationLoading = true;
    notifyListeners();

    // if (position != null) {
    final verifyResponse = await BeneficiaryApi().physicalVerifyPost(
      id: id,
      latitude: latitude, //position.latitude,
      longitude: longitude, //position.longitude,
      dlcQuestion: dlcQuestion,
      status: status,
      reason: reason ?? '',
    );
    if (verifyResponse != "Error") {
      isVerifySuccess = true;
      isVerificationLoading = false;

      //CustomSnackBar(message: 'Verification submitted Successfully', isSuccess: true).show();
    } else if (verifyResponse == 'TimeOut') {
      isVerifySuccess = true;
      CustomSnackBar(message: 'Data Saved locally Due to low network signal', isSuccess: true).show();
    } else {
      isVerifySuccess = false;
      isVerificationLoading = false;
      notifyListeners();
      //CustomSnackBar(message: 'Failed to submit', isSuccess: false).show();
    }
    // } else {
    //   isVerifySuccess = false;
    //   isVerificationLoading = false;
    //   notifyListeners();
    //   CustomSnackBar(message: 'Please enable location', isSuccess: false).show();
    // }
    return isVerifySuccess;
  }

  bool _isPhysVerifRejectSelected = false;
  bool get isPhysVerifRejectSelected => _isPhysVerifRejectSelected;

  String _phyVerifStatus = '';
  String get phyVerifStatus => _phyVerifStatus;

  clearPysVerifStatus() {
    _phyVerifStatus = '';
    _isPhysVerifRejectSelected = false;
    notifyListeners();
  }

  setPhysicalVerifyStatus() {
    if (phyVerifStatus.isEmpty) {
      _phyVerifStatus = 'Verify';
    } else {
      return;
    }
  }

  setPhysVerifRejected({bool isRej = false}) {
    if (isRej) {
      _isPhysVerifRejectSelected = true;
      _phyVerifStatus = 'Reject';
    } else {
      _isPhysVerifRejectSelected = false;
      _phyVerifStatus = 'Verify';
    }
    //  _isPhysVerifRejectSelected = !_isPhysVerifRejectSelected;
    notifyListeners();
  }

  List<int> _listOfSelectedbenfIDForwarded = [];
  List<int> get listOfSelectedForwarded => _listOfSelectedbenfIDForwarded;

  addBenficiariesID({required int index}) {
//_listOfSelectedbenfIDForwarded = [];
    chLeWiseBenfList[index].isCheck = !chLeWiseBenfList[index].isCheck;
    if (chLeWiseBenfList[index].isCheck) {
      if (!listOfSelectedForwarded.contains(chLeWiseBenfList[index].benfData!.id!)) {
        _listOfSelectedbenfIDForwarded.add(chLeWiseBenfList[index].benfData!.id!);
      }
    } else {
      _listOfSelectedbenfIDForwarded.remove(chLeWiseBenfList[index].benfData!.id!);
    }
    dev.log('ids count ${jsonEncode(listOfSelectedForwarded)}');
    // if (listOfSelectedForwarded.contains(beID)) {
    //   CustomSnackBar(message: 'Already Selected').show();
    // } else {

    // }

    notifyListeners();
  }

  clearListForSelForward() {
    listOfSelectedForwarded.clear();
    notifyListeners();
  }

  List<SendBackModel> _latVersendBackList = [];
  List<SendBackModel> get latVersendBackList => _latVersendBackList;

  getSendBackList({required int id, required BuildContext context}) async {
    _latVersendBackList = [];
    List<SendBackModel>? tempLatrSendBack;
    tempLatrSendBack = await DlcLatrineVerificationApi().getSendBackReasonsData(id: id);
    if (tempLatrSendBack != null) {
      _latVersendBackList = tempLatrSendBack;
    } else {
      CustomSnackBar(message: 'Failed to get Data', isSuccess: false).show();
    }
    notifyListeners();
  }

  List<LeGivenAnswerModel> _getLeScreeningQa = [];
  List<LeGivenAnswerModel> get getLeScreeningQa => _getLeScreeningQa;

  List<CheckUpdatedLeQuestions> _chkUpdateLeScreeningData = [];
  List<CheckUpdatedLeQuestions> get chkUpdateLeScreeningData => _chkUpdateLeScreeningData;

//update screening answer
  Future<void> getUpdatedLeQuesAnsData({
    required int benfID,
  }) async {
    _chkUpdateLeScreeningData = [];

    var getLEqList = await LeDashboardApi().getLeGivenQuestion(id: benfID);

    if (getLEqList != null) {
      for (var element in getLEqList) {
        _chkUpdateLeScreeningData.add(CheckUpdatedLeQuestions(legiven: element, value: element.isAnswer));
      }
    } else {
      dev.log('failed');
    }

    notifyListeners();
  }

  editupdatedLeScreeningQuestion({required int value, required int index}) {
    _chkUpdateLeScreeningData[index].value = value;
    dev.log('Answer Data $value');
    //  dev.log('Answer list ${jsonEncode(chDlcQuestion)}');
    notifyListeners();
  }

  getAllEditedUpdLeScreeningAnswer() {
    List<LeUpdScrnAnswer> temp = [];
    _getEditedScreeningAnswer = [];
    //var t = chDlcQuestion.map((e) => null)
    for (var element in chkUpdateLeScreeningData) {
      _getEditedScreeningAnswer.add(LeUpdScrnAnswer(
        id: element.legiven.id,
        answer: element.value.toString(),
      ));
    }
    dev.log('answer data ${jsonEncode(getEditedScreeningAnswer)}');
    notifyListeners();
  }

//update le
  getLeScreeningQuesans({required int id, required BuildContext context}) async {
    _latVersendBackList = [];
    List<LeGivenAnswerModel>? tempLatrSendBack;
    tempLatrSendBack = await LeDashboardApi().getLeGivenQuestion(id: id);
    if (tempLatrSendBack != null) {
      _getLeScreeningQa = tempLatrSendBack;
    } else {
      CustomSnackBar(message: 'Failed to get Data', isSuccess: false).show();
    }
    notifyListeners();
  }

  Future<bool> requestSelectedBeneficiaries() async {
    bool isSuccess = false;
    final isApiSuccess = await HcpHssFrwrdApi().selectForwardedData(
      ids: listOfSelectedForwarded,
    );
    if (isApiSuccess) {
      isSuccess = true;
      // CustomSnackBar(message: 'Operation Success', isSuccess: true).show();
    } else {
      isSuccess = false;
      // CustomSnackBar(message: 'Failed', isSuccess: false).show();
    }
    return isSuccess;
  }

  Future<bool> sendBackHHsFromDlc() async {
    bool isSuccess = false;
    final isApiSuccess = await HcpHssFrwrdApi().sendBackselectedData(
      ids: listOfSelectedForwarded,
    );
    if (isApiSuccess) {
      isSuccess = true;
      // CustomSnackBar(message: 'Operation Success', isSuccess: true).show();
    } else {
      isSuccess = false;
      // CustomSnackBar(message: 'Failed', isSuccess: false).show();
    }
    return isSuccess;
  }

  sendSelFrward() async {
    var res = await HcpHssFrwrdApi().sendSelectedForwarded(listOfSelectedForwarded);
    if (res.statusCode == 200 || res.statusCode == 201) {
      CustomSnackBar(message: 'Operation Success', isSuccess: true).show();
    } else {
      CustomSnackBar(message: 'Operation Failed', isSuccess: false).show();
    }
  }

  bool hcphhs = false;
  bool lehhs = false;
  bool latworks = false;

  List<dynamic> _allPermList = [];
  List<dynamic> get allPermList => _allPermList;
  List<dynamic> _permList = [];
  List<dynamic> get permList => _permList;
  checkdlcLatrineMenuAccessPermission() {
    _allPermList = [];
    _permList = [];
    var latMenuAccessPerm = allUserPermission
        .where((element) =>
            (element == "Twin Pit Latrine HCP HHs Access") &&
            (element == "Twin Pit Latrine LE-HHs Access") &&
            (element == "twin_pit_latrine_works_access"))
        .toList();
    if (latMenuAccessPerm.isNotEmpty) {
      _allPermList.addAll(latMenuAccessPerm);
    } else {
      _permList.addAll(allUserPermission.where((element) =>
          (element == "Twin Pit Latrine HCP HHs Access") ||
          (element == "Twin Pit Latrine LE-HHs Access") ||
          (element == "twin_pit_latrine_works_access")));
    }

    //notifyListeners();
  }

  //for LE ques
  List<DlcQuestionModel> _getLEQuesList = [];
  List<DlcQuestionModel> get getLEQuesList => _getLEQuesList;

  List<DlcQAnsModel> _getLEAnswer = [];
  List<DlcQAnsModel> get getLEAnswer => _getLEAnswer;

  List<LeUpdScrnAnswer> _getEditedScreeningAnswer = [];
  List<LeUpdScrnAnswer> get getEditedScreeningAnswer => _getEditedScreeningAnswer;

  List<CheckDlcQuestions> _chLEQuestion = [];
  List<CheckDlcQuestions> get chLEQuestion => _chLEQuestion;

  // List<DlcSendBQAModel>? _getsendBackAnswer = [];
  // List<DlcSendBQAModel>? get getsendBackAnswer => _getsendBackAnswer;
  //end Le

  //for latrine verification
  List<DlcQuestionModel> _getDlcQuesList = [];
  List<DlcQuestionModel> get getDlcQuesList => _getDlcQuesList;

  List<DlcQAnsModel> _getdlcAnswer = [];
  List<DlcQAnsModel> get getdlcAnswer => _getdlcAnswer;
  List<DlcQAnsModel> _getdlcAnswerForPhysicalVerif = [];
  List<DlcQAnsModel> get getdlcAnswerForPhysicalVerif => _getdlcAnswerForPhysicalVerif;
  List<DlcSendBQAModel>? _getsendBackAnswer = [];
  List<DlcSendBQAModel>? get getsendBackAnswer => _getsendBackAnswer;

  List<CheckDlcQuestions> _chDlcQuestion = [];
  List<CheckDlcQuestions> get chDlcQuestion => _chDlcQuestion;

  List<CheckDlcSendbackQuestions> _chDlcSendBackQuestion = [];
  List<CheckDlcSendbackQuestions> get chDlcSendBackQuestion => _chDlcSendBackQuestion;

  List<CheckDlcQuestionsForPhysicalVerify> _dlcPhvQuesList = [];
  List<CheckDlcQuestionsForPhysicalVerify> get dlcPhvQuesList => _dlcPhvQuesList.distinctBy((element) => element.dlcQ.id).toList();

  List tstList = [3, 4, 2, 3, 1, 2, 3, 1, 2, 2, 3, 3];

  tstdList() {
    var newList = tstList.distinct().toList();
    for (var element in newList) {
      dev.log('testl $element');
    }
  }

  Future<void> getDlcQuestionsForPhysicalVerify(LocalStoreHiveProvider local, OperationProvider op) async {
    _dlcPhvQuesList = [];

    if (op.isConnected) {
      local.dlcQABox.clear();
      var getqList = await BeneficiaryApi().getPhysicalVerifyQuestionsForDlc();
      if (getqList != null && getqList.isNotEmpty) {
        //  local.dlcQABox.clear();
        for (var element in getqList) {
          local.storeDlcQuesAns(LocalDlcQuesAns(
            id: element.id.toString(),
            title: element.title,
            type: element.type,
          ));
          _dlcPhvQuesList.add(CheckDlcQuestionsForPhysicalVerify(dlcQ: element, value: null));
        }
        //
      } else {
        var localQList = local.dlcQABox.values.toList();
        if (localQList.isNotEmpty) {
          localQList.forEach((e) {
            _dlcPhvQuesList.add(CheckDlcQuestionsForPhysicalVerify(
                dlcQ: DlcQuestionModel(
                  id: int.parse(e.id ?? ""),
                  title: e.title,
                  type: e.type,
                ),
                value: null));
          });
          // _dlcPhvQuesList.distin
        } else {
          _dlcPhvQuesList = [];
        }
        // dev.log('failed');
      }
    } else {
      var localQList = local.dlcQABox.values.toList();
      if (localQList.isNotEmpty) {
        localQList.forEach((e) {
          _dlcPhvQuesList.add(CheckDlcQuestionsForPhysicalVerify(
              dlcQ: DlcQuestionModel(
                id: int.parse(e.id ?? ""),
                title: e.title,
                type: e.type,
              ),
              value: null));
        });
        // _dlcPhvQuesList.distin
      } else {
        _dlcPhvQuesList = [];
      }
    }

    notifyListeners();
  }

  clearDlcQuesAns() {
    _dlcPhvQuesList.clear();
    notifyListeners();
  }

  Future<void> getDlcQuestionsData({
    required int benfID,
  }) async {
    _chDlcQuestion = [];
    _chDlcSendBackQuestion = [];
    var getqList = await DlcLatrineVerificationApi().getDlcQuestions();
    var getSendBackQuestionList = await DlcLatrineVerificationApi().getSendBackReasonsData(
      id: benfID,
    );
    if (getqList.isNotEmpty) {
      for (var element in getqList) {
        _chDlcQuestion.add(CheckDlcQuestions(dlcQ: element, value: null));
      }
    } else {
      dev.log('failed');
    }
    if (getSendBackQuestionList != null) {
      for (var element in getSendBackQuestionList) {
        _chDlcSendBackQuestion.add(CheckDlcSendbackQuestions(dlcsendQ: element, value: element.isResolved));
      }
    } else {
      _chDlcSendBackQuestion = [];
    }
    notifyListeners();
  }

  updateQuestionDlcList({required int value, required int index}) {
    _chDlcQuestion[index].value = value;
    dev.log('Answer Data $value');
    //  dev.log('Answer list ${jsonEncode(chDlcQuestion)}');
    notifyListeners();
  }

  updatePhvQuestionDlcList({required int value, required int index}) {
    _dlcPhvQuesList[index].value = value;
    dev.log('Answer Data $value');
    //  dev.log('Answer list ${jsonEncode(chDlcQuestion)}');
    notifyListeners();
  }

  updateSendbackQuestionDlcList({required int value, required int index}) {
    _chDlcSendBackQuestion[index].value = value;
    dev.log('Answer Data $value');
    //  dev.log('Answer list ${jsonEncode(chDlcQuestion)}');
    notifyListeners();
  }

  getAllDlcAnswer() {
    List<DlcQAnsModel> temp = [];
    _getdlcAnswer = [];
    //var t = chDlcQuestion.map((e) => null)
    for (var element in chDlcQuestion) {
      _getdlcAnswer.add(DlcQAnsModel(
        questionId: element.dlcQ.id,
        answer: element.value.toString(),
      ));
    }
    dev.log('answer data ${jsonEncode(getdlcAnswer)}');
    notifyListeners();
  }

  getDlcAnswerForPhysicalVerif() {
    List<DlcQAnsModel> temp = [];
    _getdlcAnswerForPhysicalVerif = [];
    //var t = chDlcQuestion.map((e) => null)
    for (var element in dlcPhvQuesList) {
      _getdlcAnswerForPhysicalVerif.add(DlcQAnsModel(
        questionId: element.dlcQ.id,
        answer: element.value.toString(),
      ));
    }
    dev.log('answer data ${jsonEncode(getdlcAnswer)}');
    notifyListeners();
  }

  clearDlcQuesAnswerphysver() {
    _getdlcAnswerForPhysicalVerif.clear();
    notifyListeners();
  }

  getAllDlcSendBackAnswer() {
    List<DlcSendBQAModel> temp = [];
    _getsendBackAnswer = [];
    //var t = chDlcQuestion.map((e) => null)
    for (var element in chDlcSendBackQuestion) {
      _getsendBackAnswer!.add(DlcSendBQAModel(
        questionId: element.dlcsendQ.id,
        answer: element.value.toString(),
      ));
    }
    dev.log('send back answer data ${jsonEncode(getsendBackAnswer)}');
    notifyListeners();
  }

  Future<bool> latrineVerificationApi({required int benfID, required List<DlcQAnsModel> getdlcAnswer}) async {
    bool isSuccess = false;
    final http.Response? resp = await DlcLatrineVerificationApi().verifyLatrineInstallation(benfiD: benfID, dlcQuestion: getdlcAnswer);
    if (resp != null && (resp.statusCode == 200 || resp.statusCode == 201)) {
      isSuccess = true;
      dev.log('Success');
    } else {
      isSuccess = false;
      dev.log('Failed');
    }
    return isSuccess;
  }

  Future<Map> sendBackLatrineVerification({required int benfID, required String comment}) async {
    bool isSuccess = false;
    final resp = await DlcLatrineVerificationApi().sendBackLatrineVerification(benfiD: benfID, comment: comment);
    return resp;
    // if (resp != null && (resp.statusCode == 200 || resp.statusCode == 201)) {
    //   isSuccess = true;
    //   dev.log('Success');
    // } else {
    //   isSuccess = false;
    //   dev.log('Failed');
    // }
    //return isSuccess;
  }

  String modalBottomErrorText = '';
  setModalBottomErrorText({bool isErrorText = false}) {
    if (isErrorText) {
      modalBottomErrorText = 'Please Write Your Reason';
      notifyListeners();
    } else {
      modalBottomErrorText = '';
      notifyListeners();
    }
  }

  String modalBottomOnVerificationErrorText = '';
  setOnVerifErrorText({bool isErrorText = false, bool isImageVal = false}) {
    if (isErrorText) {
      if (isImageVal) {
        modalBottomOnVerificationErrorText = 'Please insert Site Image';
      } else {
        modalBottomOnVerificationErrorText = 'Please Check All Answer';
      }

      notifyListeners();
    } else {
      modalBottomOnVerificationErrorText = '';
      notifyListeners();
    }
  }

  //Leques
  Future<void> getLEQuestionsData({
    required int benfID,
  }) async {
    _chLEQuestion = [];

    var getLEqList = await LeDashboardApi().getLEQuestions();

    if (getLEqList.isNotEmpty) {
      for (var element in getLEqList) {
        _chLEQuestion.add(CheckDlcQuestions(dlcQ: element, value: null));
      }
    } else {
      dev.log('failed');
    }

    notifyListeners();
  }

  updateLeScreeningQuestion({required int value, required int index}) {
    _chLEQuestion[index].value = value;
    dev.log('Answer Data $value');
    //  dev.log('Answer list ${jsonEncode(chDlcQuestion)}');
    notifyListeners();
  }

  getAllLeScreeningAnswer() {
    List<DlcQAnsModel> temp = [];
    _getLEAnswer = [];
    //var t = chDlcQuestion.map((e) => null)
    for (var element in chLEQuestion) {
      _getLEAnswer.add(DlcQAnsModel(
        questionId: element.dlcQ.id,
        answer: element.value.toString(),
      ));
    }
    dev.log('answer data ${jsonEncode(getLEAnswer)}');
    notifyListeners();
  }

  //For Location
  String _locationServiceStatus = '';
  String get locationServiceStatus => _locationServiceStatus;

  bool _isServiceEnabled = false;
  bool get isServiceEnabled => _isServiceEnabled;

  StreamSubscription<geo.ServiceStatus>? _serviceStatusStream;
  StreamSubscription<geo.ServiceStatus>? get serviceStatusStream => _serviceStatusStream;

  locationServiceStatusStream() {
    _serviceStatusStream = geo.Geolocator.getServiceStatusStream().listen((geo.ServiceStatus status) {
      _locationServiceStatus = status.name;
      dev.log('permission now going ${locationServiceStatus}');
      notifyListeners();
    });
  }

  Future<bool> checkLocationServiceStatus() async {
    bool isServiceEnable = false;
    isServiceEnable = await geo.Geolocator.isLocationServiceEnabled();

    return isServiceEnable;
  }

  checkLocationPermission() {}

  bool isDividerTabSelected = false;

  int selectedTabIndex = 0;

  setDividerTab(int index) {
    selectedTabIndex = index;
    // isDividerTabSelected = !isDividerTabSelected;
    notifyListeners();
  }

  // List<Message> _eventMessage = [];
  // List<Message> get eventMessage => _eventMessage;

  dynamic userID;

  getUserID() async {
    userID = await LocalStorageManager.readData(ApiConstant.userID) ?? "Unknown id";
  }

  // PusherNotifModel? _pusherModel = PusherNotifModel();
  // PusherNotifModel? get pusherModel => _pusherModel;

  // onEvent(PusherEvent event) {
  //   _pusherModel = PusherNotifModel();
  //   var eventbyChannel = PusherEvent(channelName: 'dphe-notification-channel', eventName: 'dphe-notification-event');
  //   print("onEvent: $event");
  //   print(eventbyChannel.userId);
  //   print(eventbyChannel.data);
  //   var pusherData = jsonDecode(eventbyChannel.data);
  //   _pusherModel = PusherNotifModel.fromJson(pusherData);
  //   if (pusherModel != null) {
  //     if (pusherModel!.message!.platform == 'all') {
  //       //pusherModel!.message!.userId == userID &&
  //       _eventMessage.add(pusherModel!.message!);
  //       notifyListeners();
  //     }
  //   }

  //   // if (pusherData['message']['user_id'] == userID) {
  //   //   _eventMessage.add(pusherData['message']);
  //   // }

  //   print('pusher data user id ${pusherData['message']['user_id']}');
  //   //notificationData = eventbyChannel.data;
  //   //print("onEvent: $event");
  //   notifyListeners();
  // }

  //for camera
  bool _isCameraPermissionGranted = false;
  bool get isCameraPermissionGranted => _isCameraPermissionGranted;

  late final Future<void> _future;
  Future<void> get future => _future;

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isCameraPermissionGranted = status == PermissionStatus.granted;
    notifyListeners();
  }

  List dummyList = ['MS', "Rahman", "Tim"];
  List<dynamic> wardDropdown = [AppConstant.allward, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<bool> _checkList = [];
  List<bool> get checkList => _checkList;

  addcheck(bool value) {
    checkList.add(value);
    //notifyListeners();
  }

  updatecheck(int index, bool value) {
    _checkList[index] = value;
    notifyListeners();
  }

  bool latrSendBackVerificationLoading = false;
  bool latrQAVerificationLoading = false;

  latrineVerificationLoader({bool isSendBack = false, bool loading = false}) {
    if (isSendBack) {
      if (loading) {
        latrSendBackVerificationLoading = true;
      } else {
        latrSendBackVerificationLoading = false;
      }

      notifyListeners();
    } else {
      if (loading) {
        latrQAVerificationLoading = true;
      } else {
        latrQAVerificationLoading = false;
      }
      notifyListeners();
    }
  }

  bool isCameraLoading = false;

  isCamLoading({required bool value}) {
    isCameraLoading = value;
    notifyListeners();
  }

  clearPrevvImg() {
    sendBackSiteImage = null;
    notifyListeners();
  }

  File? sendBackSiteImage;

  getFromCamera({bool isCamera = false, required BuildContext ctx}) async {
    sendBackSiteImage = null;
    notifyListeners();
    //XFile? pickedFile;
    if (isCamera) {
      var camModel = await Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (context) => CaptureImage(),
          ));
      if (camModel != null && camModel is CameraDataModel) {
        if (camModel.xpictureFile != null) {
          saveSeImage(pickedImage: camModel.xpictureFile!);
        } else {
          return;
        }
      } else {
        return;
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        saveSeImage(
          pickedImage: pickedFile,
        );
      }
    }
  }

  Future<void> saveSeImage({
    required XFile pickedImage,
  }) async {
    final imgByte = await getUint8ListFile(File(pickedImage.path));
    final appDir = await getApplicationDocumentsDirectory(); // Or any other directory you prefer
    final uniqueFileName = DateTime.now().microsecondsSinceEpoch;
    final savedImage = File('${appDir.path}/dphe/$uniqueFileName.jpg');

    // Create the folder if it doesn't exist
    final folder = Directory('${appDir.path}/dphe');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    await savedImage.writeAsBytes(imgByte!);
    // await savedImage.writeAsBytes(await pickedImage.readAsBytes());

    // You can now access the saved image using savedImage.path
    //await getLocation();

    sendBackSiteImage = File(savedImage.path);
    notifyListeners();
  }

  Future<XFile> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
      rotate: 0,
    );

    print(file.lengthSync());
    print(result!.length());

    return result;
  }

  List<Placemark> _placemarks = [];
  List<Placemark> get placemark => _placemarks;

  Future getAddress({double? lat, double? lang}) async {
    if (lat == null || lang == null) {
      return null;
    }
    try {
      _placemarks = await placemarkFromCoordinates(
        lat,
        lang,
      );
    } catch (e) {
      _placemarks = [];
    }

    notifyListeners();
  }

  //storing image url to file
  Future<File> convertUrlToFile(String imageUrl) async {
    //var rng = new Random();
    Directory tempDir = await getApplicationDocumentsDirectory();
    final uniqueFileName = DateTime.now().microsecondsSinceEpoch;
    final tempPath = tempDir.path;
    File file = File('$tempPath/dphe/$uniqueFileName.jpg');
    final folder = Directory('$tempPath/dphe');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<Uint8List?> getUint8ListFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1920,
      minHeight: 1080,
      quality: 60,
      rotate: 0,
    );
    print(file.lengthSync());
    print('compressed image ${result!.length}');
    return result;
  }

  Future<String?> getStoreVersion(String myAppBundleId) async {
    String? storeVersion;
    if (Platform.isAndroid) {
      PlayStoreSearchAPI playStoreSearchAPI = PlayStoreSearchAPI();
      Document? result = await playStoreSearchAPI.lookupById(myAppBundleId, country: 'BD');
      if (result != null) storeVersion = playStoreSearchAPI.version(result);
      dev.log('PlayStore version: $storeVersion}');
    } else {
      storeVersion = null;
    }
    return storeVersion;
  }

  String _currentVersionNumber = '';
  String get currentVersionNumber => _currentVersionNumber;

  Future<bool> checkUpdateAvailable() async {
    bool isUpdateAvailable = false;
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _currentVersionNumber = packageInfo.version;
      notifyListeners();
      String? currentStoreVersion = await getStoreVersion('com.dream71.dphe');
      if (currentStoreVersion == null) return false;
      if (Version.parse(currentStoreVersion) > Version.parse(currentVersionNumber)) {
        isUpdateAvailable = true;
      } else {
        isUpdateAvailable = false;
      }
    } on Exception catch (e) {
      isUpdateAvailable = true;
    }

    return isUpdateAvailable;
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: 96,
      rotate: 0,
    );
    print(list.length);
    print(result.length);
    return result;
  }

  bool isCamSelected = false;

  toggleGalleryOrCam() {
    isCamSelected = !isCamSelected;
    notifyListeners();
  }

  // Future<Uint8List> testComporessList(Uint8List list) async {
  //   var result = await FlutterImageCompress.compressWithList(
  //     list,
  //     minHeight: 1920,
  //     minWidth: 1080,
  //     quality: 96,
  //     rotate: 135,
  //   );
  //   print(list.length);
  //   print(result.length);
  //   return result;
  // }

  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityResult get connectivityResult => _connectivityResult;
  bool get isConnected => _connectivityResult != ConnectivityResult.none;
  late StreamSubscription<String> localBackupDeleteOperation;

  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  bool isBackUpComplete = false;

  initConnection({
    OperationProvider? op,
    LocalStoreHiveProvider? local,
    SyncOnlineProvider? sync,
  }) {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((event) async {
      _connectivityResult = event;

      notifyListeners();
      if (isConnected) {
        final userType = await LocalStorageManager.readData(AppConstant.userType) ?? "";
        dev.log('user Type$userType');
        if (userType == 'dlc') {
          dev.log('user Type$userType dlc true');
          //await local!.backupDlcVerification(op!);
        } else if (userType == 'le') {
          await sync!.isDataSync();
        } else {
          return;
        }

        isBackUpComplete = true;
      } else {
        isBackUpComplete = false;
      }

      dev.log('...$_connectivityResult');
      dev.log('...network connected $isConnected');
      notifyListeners();
    });
  }

  Future searchUriFromInternet({String? uriName, bool isSupport = false, required String phone}) async {
    Uri? uriSearch;
    //final String prodDetailsUrl = 'https://www.google.com/search?q=$uriName';
    if (isSupport) {
      uriSearch = Uri.tryParse('tel:+88$phone'); //01312527111
    } else {
      uriSearch = Uri.tryParse('https://play.google.com/store/apps/details?id=com.dream71.dphe');
    }

    if (await launchUrl(uriSearch!)) {
      await launchUrl(uriSearch, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uriSearch';
    }
  }

  String getTwinPitLatrineDetTitle(dynamic item) {
    String title = '';

    switch (item) {
      case "Twin Pit Latrine HCP HHs Access":
        title = "HCP HHs";

        break;
      case "Twin Pit Latrine LE-HHs Access":
        title = "LE-HHs";
        break;
      case "twin_pit_latrine_works_access":
        title = "Latrine-works";
        break;
      default:
    }
    return title;
  }

  //final List

  final List<DlcDashBoardModel> _dlcDashBoardPageList = [
    DlcDashBoardModel(
      id: "1",
      title: "Attendance",
      tileColor: MyColors.customGreen,
      routeName: AttendanceScreen(),
    ),
    DlcDashBoardModel(
      id: "2",
      title: "Leave Requests",
      tileColor: MyColors.customRed,
      routeName: LeaveHistoryPage(),
    ),

    DlcDashBoardModel(
      id: "3",
      title: "Twin Pit Latrine Activities",
      tileColor: MyColors.customRed2,
      routeName: TwinpitActivityDetails(
        title: "Twin Pit Latrine",
      ),
    ),

    // DlcDashBoardModel(
    //     id: "3",
    //     title: "Twin Pit Latrine HCP HHs",
    //     tileColor: const Color.fromARGB(255, 151, 119, 109),
    //     routeName: MyDistrictPage(),
    //     ),
    // DlcDashBoardModel(
    //     id: "4",
    //     title: "Twin Pit Latrine Beneficiary Forward",
    //     tileColor: Colors.brown.shade600,
    //     ),
    // DlcDashBoardModel(
    //     id: "5",
    //     title: "Twin Pit Latrine Verification",
    //     tileColor: const Color.fromARGB(255, 181, 50, 204),
    //     ),
    // DlcDashBoardModel(id: "4", title: "Beneficiary Mapping", tileColor: MyColors.benfMappingTile),
    DlcDashBoardModel(
      id: "5",
      title: "Other Activity",
      tileColor: MyColors.customGreenLight,
      routeName: const MyDistrictPage(
        isHcpVerificationPage: false,
        isHcpForwardPage: false,
        isLatrineVerification: false,
        isOtherActivity: true,
        isReporting: false,
      ),
    ),
    // DlcDashBoardModel(id: "6", title: "Reporting", tileColor: MyColors.reportingTile, routeName: DlcReportList(upazilaName: '', upaID: 0, distID: 0)
    // routeName: const MyDistrictPage(
    //   isHcpVerificationPage: false,
    //   isHcpForwardPage: false,
    //   isLatrineVerification: false,
    //   isOtherActivity: false,
    //   isReporting: true,
    // ),
    // ),
  ];

  List<DlcDashBoardModel> get dlcDashBoardPageList => _dlcDashBoardPageList;

  final List<DlcDashBoardModel> _twinPitActivitiesDshBoardList = [
    DlcDashBoardModel(
      id: "1",
      title: "HCP HHs Verification ",
      tileColor: const Color.fromARGB(255, 151, 119, 109),
      routeName: MyDistrictPage(
        isHcpVerificationPage: true,
        isHcpForwardPage: false,
        isLatrineVerification: false,
        isOtherActivity: false,
        isReporting: false,
      ),
    ),
    DlcDashBoardModel(
      id: "2",
      title: "LE-HHs Forward",
      tileColor: Colors.brown.shade600,
      routeName: const MyDistrictPage(
        isHcpForwardPage: true,
        isHcpVerificationPage: false,
        isLatrineVerification: false,
        isOtherActivity: false,
        isReporting: false,
      ),
    ),
    DlcDashBoardModel(
      id: "3",
      title: "Latrine installation Verification",
      tileColor: const Color.fromARGB(255, 181, 50, 204),
      routeName: const MyDistrictPage(
        isHcpVerificationPage: false,
        isHcpForwardPage: false,
        isLatrineVerification: true,
        isOtherActivity: false,
        isReporting: false,
      ),
    ),
  ];
  List<DlcDashBoardModel> get twinPitActivitiesDshBoardList => _twinPitActivitiesDshBoardList;
//for hhs cp forward
  List<CustomTabModel> _cTablist = [
    CustomTabModel(id: 1, title: "Pending"),
    CustomTabModel(id: 2, title: "Forwarded"),
  ];
  List<CustomTabModel> get cTablist => _cTablist;
//for hhs cp forward
  final List<CustomTabModel> _pfverifyList = [
    CustomTabModel(id: 1, title: "Pending"),
    CustomTabModel(id: 2, title: "Verified"),
    CustomTabModel(id: 3, title: 'Send Back')
  ];
  List<CustomTabModel> get pfverifyList => _pfverifyList;
}

class DlcDashBoardModel {
  final String? title;
  final String? id;
  final Color? tileColor;
  final Widget? routeName;

  DlcDashBoardModel({
    this.title,
    this.id,
    this.tileColor,
    this.routeName,
  });
}

class CustomTabModel {
  final int? id;
  final String? title;

  CustomTabModel({this.id, this.title});
}

class LatrineAccessModel {
  final String? id;
  final String? name;

  LatrineAccessModel({this.id, this.name});
}

class CheckBeneficiartModel {
  final BeneficiaryDetailsData? benfData;
  bool isCheck;

  CheckBeneficiartModel({required this.benfData, this.isCheck = false});
}

class CheckDlcQuestions {
  final DlcQuestionModel dlcQ;
  int? value;

  CheckDlcQuestions({required this.dlcQ, this.value});
}

class CheckDlcQuestionsForPhysicalVerify {
  final DlcQuestionModel dlcQ;
  int? value;

  CheckDlcQuestionsForPhysicalVerify({required this.dlcQ, this.value});
}

class CheckDlcSendbackQuestions {
  final SendBackModel dlcsendQ;
  int? value;

  CheckDlcSendbackQuestions({required this.dlcsendQ, this.value});
}

class CheckUpdatedLeQuestions {
  final LeGivenAnswerModel legiven;
  int? value;

  CheckUpdatedLeQuestions({required this.legiven, this.value});
}
