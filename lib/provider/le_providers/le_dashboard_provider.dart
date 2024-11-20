import 'dart:async';
import 'dart:developer';
import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/api/le_dashboard_api/le_dashboard_api.dart';
import 'package:dphe/Data/models/common_models/union_dropdown_model.dart';
import 'package:dphe/Data/models/common_models/upazila_dropdown_model.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../Data/models/le_models/benificiary_models/non_selected_benificiary_list_model.dart';
import '../../Data/models/le_models/le_dashboard_models/image_response_model.dart';
import '../../Data/models/le_models/le_dashboard_models/le_dashboard.dart';
import '../../offline_database/db_tables/le_tables/beneficiary_list_table.dart';
import '../../offline_database/db_tables/le_tables/latrine_progress_table.dart';
import '../../utils/app_constant.dart';
import '../../utils/common_functions.dart';
import '../../utils/local_storage_manager.dart';
import '../network_connectivity_provider/network_connectivity_provider.dart';

class LeDashboardProvider extends ChangeNotifier {
  List<DropdownUpazila> upazilaList = [];
  List<DropdownUnion> unionList = [];
  // List<BeneficiaryDetailsData> _nonSelectedBeneficiaryList = [];
  //  List<BeneficiaryDetailsData> get nonSelectedBeneficiaryList => _nonSelectedBeneficiaryList;
  List<BeneficiaryDetailsData> nonSelectedBeneficiaryList = [];
  List<LeDashboardModel> leDashboardDataList = [];
  List<LatrineImageResponse> latrineImageList = [];

  int countdown = 60;
  bool isTimerOn = false;
  bool isAnsSubmitted = false;
  late Timer timer;
  bool showLeDashboard = false;
  bool networkConnected = false;
  bool isLocationPermissionEnabled = false;

  Future<void> getLeDashboard() async {
    final isConnected = await NetworkConnectivity().checkConnectivity();

    /// internet connectivity function call
    if (isConnected == true) {
      /// if connected to the internet
      leDashboardDataList.clear();
      final res = await LeDashboardApi().getLeDashboardApi();
      if (res != null) {
        leDashboardDataList.add(res);
        networkConnected = true;
        showLeDashboard = true;
        // LocalStorageManager.saveData(AppConstant.leDashboardUnderSelectionCount, res.underSelection!.count??0);
        // LocalStorageManager.saveData(AppConstant.leDashboardApprovedSelectionCount, res.approved!.count??0);
        // LocalStorageManager.saveData(AppConstant.leDashboardOngoingCount, res.ongoing!.count??0);
        // LocalStorageManager.saveData(AppConstant.leDashboardUnderVerificationCount, res.underVerification!.count??0);
        // LocalStorageManager.saveData(AppConstant.leDashboardVerifiedCount, res.verified!.count??0);
        LocalStorageManager.saveData(AppConstant.leDashboardUnderSelectionCount, res.underSelection?.count ?? 0);
        LocalStorageManager.saveData(AppConstant.leDashboardApprovedSelectionCount, res.approved?.count ?? 0);
        LocalStorageManager.saveData(AppConstant.leDashboardOngoingCount, res.ongoing?.count ?? 0);
        LocalStorageManager.saveData(AppConstant.leDashboardUnderVerificationCount, res.underVerification?.count ?? 0);
        LocalStorageManager.saveData(AppConstant.leDashboardVerifiedCount, res.verified?.count ?? 0);
        LocalStorageManager.saveData(AppConstant.leDashboardBillPaid, res.billPaid?.count ?? 0);
        notifyListeners();
      }
    } else {
      ///if no internet then do something
      networkConnected = false;
      showLeDashboard = true;
      notifyListeners();
    }
  }

  clearNonSelBenf() {
    nonSelectedBeneficiaryList.clear();
    notifyListeners();
  }

  void removeBeneficiary({required int index}) {
    nonSelectedBeneficiaryList.removeAt(index);
    notifyListeners();
  }

  void setLocationPermission({required bool permission}) {
    isLocationPermissionEnabled = permission;
    notifyListeners();
  }

  // void getUpazilaList({required int districtId})async{
  //   print("districtId $districtId");
  //   final res = await LeDashboardApi().getUpazillaDropdownApi(districtId: districtId);
  //   if(res !=null ){
  //     upazilaList = res.data!.upazila!;
  //   }
  //   print("upazilaList.length ${upazilaList.length}");
  //   notifyListeners();
  // }

  void getUpazilaList({required int districtId}) async {
    UpazilaDropdownModel? jsonData = await CommonFunctions().getUpazilaJsonData();
    upazilaList.clear();
    if (jsonData!.data!.upazila!.isNotEmpty) {
      for (int i = 0; i < jsonData.data!.upazila!.length; i++) {
        if (jsonData.data!.upazila![i].districtId == districtId) {
          upazilaList.add(jsonData.data!.upazila![i]);
        }
      }
      notifyListeners();
    }
  }

  ///online UNION data
  // void getUnionList({required int upazilaId})async{
  //   print("districtId $upazilaId");
  //   final res = await LeDashboardApi().getUnionDropdownApi(upazilaId: upazilaId);
  //   if(res !=null ){
  //     unionList = res.data!.union!;
  //   }
  //   print("unionList.length ${unionList.length}");
  //   notifyListeners();
  // }

  void getUnionList({required int upazilaId}) async {
    UnionDropdownModel? jsonData = await CommonFunctions().getUnionJsonData();
    unionList.clear();
    if (jsonData!.data!.union!.isNotEmpty) {
      //unionList = jsonData.data!.union!.where((element) => element.upazilaId == upazilaId).toList as List<DropdownUnion>;
      for (int i = 0; i < jsonData.data!.union!.length; i++) {
        if (jsonData.data!.union![i].upazilaId == upazilaId) {
          unionList.add(jsonData.data!.union![i]);
        }
      }
      notifyListeners();
    }
  }

  bool isLeBenfLoading = false;
  int _totalData = 0;
  int get totalData => _totalData;

  int _lepaginatedPageNo = 1;
  int get lepaginatedPageNo => _lepaginatedPageNo;
  bool islePaginatedLoading = false;
  bool hasMore = true;

  Future<void> fetchNonSelectedPaginatedLeBenf({
    required List statusIdList,
    int? upazilaId,
    int? unionId,
    int? wardNo,
    String? searchQuery,

    // required int rows,
    required OperationProvider op,
    // LocalStoreHiveProvider? local,
  }) async {
    if (islePaginatedLoading) return;
    islePaginatedLoading = true;
    if (op.isConnected) {
      //getLocalPhverData(local: local!, upaID: upazilaID);
      final getBenificiaryData = await LeDashboardApi().getNonSelectedBeneficiaryListApi(
        statusIdList: statusIdList,
        upazillaId: upazilaId,
        unionId: unionId,
        phoneOrLe: searchQuery,
        pageNo: lepaginatedPageNo,
        wardNo: wardNo,

        //rows: rows,
      );
      // if (getBenificiaryData ) {

      // }

      final fetchedbeneficiaryList = getBenificiaryData?.data ?? [];
      _lepaginatedPageNo++;
      islePaginatedLoading = false;
      if (fetchedbeneficiaryList.length < 15) {
        hasMore = false;
      }

      nonSelectedBeneficiaryList.addAll(fetchedbeneficiaryList);
      //  if (statusIdList[0] == 10) {
      //     print('statusIDS [10] true');
      //     for (var element in nonSelectedBeneficiaryList) {
      //       final res = await LatrineProgressTable().getSingleImage(beneficiaryId: element.id!);
      //       if (res == null) {
      //         final res = await LatrineProgressTable().insertImage(
      //             beneficiaryId: element.id!.toInt(),
      //             isCompleted: 0,
      //             photoStep1: "",
      //             photoStep2: "",
      //             photoStep3: "",
      //             photoStep4: "",
      //             photoStep5: "",
      //             photoStep1sts: "",
      //             photoStep2sts: "",
      //             photoStep3sts: "",
      //             photoStep4sts: "",
      //             photoStep5sts: "",
      //             latitude: "",
      //             longitude: "");
      //         print(res);
      //         // await updateImgFrmInternet(beneficiaryId: element.id!, op: op);
      //         print('img upd done');
      //       } else {
      //         await updateImgFrmInternet(beneficiaryId: element.id!, op: op);
      //       }
      //     }
      //  }
      for (var i = 0; i < nonSelectedBeneficiaryList.length; i++) {
        await BeneficiaryListTable().insertBeneficiary(
            id: nonSelectedBeneficiaryList[i].id!,
            name: nonSelectedBeneficiaryList[i].name ?? "",
            banglaName: nonSelectedBeneficiaryList[i].banglaname ?? "",
            phone: nonSelectedBeneficiaryList[i].phone ?? "",
            type: nonSelectedBeneficiaryList[i].type ?? "",
            address: nonSelectedBeneficiaryList[i].address ?? "",
            nid: nonSelectedBeneficiaryList[i].nid ?? 0,
            photo: nonSelectedBeneficiaryList[i].photo ?? "",
            sendBackReason: nonSelectedBeneficiaryList[i].sendBackReason ?? "",
            fatherOrHusbandName: nonSelectedBeneficiaryList[i].fatherOrHusbandName ?? "",
            //  status: res.data![i].status ?? 0,
            religion: nonSelectedBeneficiaryList[i].religion ?? "",
            gender: nonSelectedBeneficiaryList[i].gender ?? "",
            latitude: nonSelectedBeneficiaryList[i].latitude ?? "",
            longitude: nonSelectedBeneficiaryList[i].longitude ?? "",
            divisionId: nonSelectedBeneficiaryList[i].divisionId ?? -10,
            districtId: nonSelectedBeneficiaryList[i].districtId ?? -10,
            upazilaId: nonSelectedBeneficiaryList[i].upazilaId ?? -10,
            unionId: nonSelectedBeneficiaryList[i].unionId ?? -10,
            wardId: nonSelectedBeneficiaryList[i].wardNo ?? -10,
            userId: nonSelectedBeneficiaryList[i].userId ?? -10,
            isSendBack: nonSelectedBeneficiaryList[i].isSendBack,
            sendBackComments: nonSelectedBeneficiaryList[i].sendBackReason,
            statusId: nonSelectedBeneficiaryList[i].statusId ?? 0,
            otpVerified: nonSelectedBeneficiaryList[i].otpVerified ?? 0,
            isQuestionAnswer: nonSelectedBeneficiaryList[i].isQuestionAnswer ?? 0,
            isLocationMatch: nonSelectedBeneficiaryList[i].isLocationMatch ?? 0,
            district: nonSelectedBeneficiaryList[i].district ?? "",
            upazila: nonSelectedBeneficiaryList[i].upazila ?? "",
            union: nonSelectedBeneficiaryList[i].union ?? "",
            junction: nonSelectedBeneficiaryList[i].junction ?? "",
            divisionName: nonSelectedBeneficiaryList[i].district?.name ?? "",
            districtName: nonSelectedBeneficiaryList[i].district?.bnName ?? "",
            upazilaName: nonSelectedBeneficiaryList[i].upazila?.bnName ?? "",
            unionName: nonSelectedBeneficiaryList[i].union?.bnName ?? "",
            // division: jsonEncode(res.data![i].division??""),
            // district: jsonEncode(res.data![i].district??""),
            // upazila: jsonEncode(res.data![i].upazila??""),
            // union: jsonEncode(res.data![i].union??""),
            createdBy: nonSelectedBeneficiaryList[i].createdBy ?? "",
            updatedBy: nonSelectedBeneficiaryList[i].updatedBy ?? "",
            deletedBy: nonSelectedBeneficiaryList[i].deletedBy ?? "");
      }
    } else {
      /// if offline then perform the following code
      final beneficiaries =
          await BeneficiaryListTable().fetchPaginatedBeneficiaries(1, 15, statusIdList, upazillaId: upazilaId ?? -10, unionId: unionId ?? -10);
      //final beneficiaries = await BeneficiaryListTable().fetchPaginatedBeneficiaries(pageNo, 15);
      //final single = await BeneficiaryListTable().getSingleBeneficiary(beneficiaryId: 5);
      //print(single);
      networkConnected = false;
      notifyListeners();
      if (beneficiaries.isNotEmpty) {
        nonSelectedBeneficiaryList = beneficiaries;
        notifyListeners();
      }
      print(beneficiaries);

      // final all = await BeneficiaryListTable().getAllData();
      // print(all.length);
    }

    notifyListeners();
  }

  Future lePaginatedRefresh() async {
    islePaginatedLoading = false;
    hasMore = true;
    _lepaginatedPageNo = 1;
    nonSelectedBeneficiaryList.clear();

    notifyListeners();
  }

  Future<void> getNonSelectedBeneficiaryList({required List statusIdList, int? upazilaId, int? unionId, int? wardNo, String? searchQuery
      // required int pageNo,
      // required int rows,
      //PagingController<int, BeneficiaryDetailsData>? pagingController,
      }) async {
    _totalData = 0;

    nonSelectedBeneficiaryList.clear();
    //notifyListeners();
    print("upazilaId $upazilaId");
    final isConnected = await NetworkConnectivity().checkConnectivity();

    /// internet connectivity function call
    if (isConnected == true) {
      isLeBenfLoading = true;
      final res = await LeDashboardApi().getNonSelectedBeneficiaryListApi(
        statusIdList: statusIdList,
        upazillaId: upazilaId,
        unionId: unionId,
        phoneOrLe: searchQuery,
        pageNo: 1,
        wardNo: wardNo,
        //rows: rows,
      );

      networkConnected = true;
      isLeBenfLoading = false;

      notifyListeners();
      if (res != null) {
        //_totalData = res.meta!.total!;
        //if(statusIdList==[0]){
        for (int i = 0; i < res.data!.length; i++) {
          nonSelectedBeneficiaryList.add(res.data![i]);

          await BeneficiaryListTable().insertBeneficiary(
              id: res.data![i].id!,
              name: res.data![i].name ?? "",
              banglaName: res.data![i].banglaname ?? "",
              phone: res.data![i].phone ?? "",
              type: res.data![i].type ?? "",
              address: res.data![i].address ?? "",
              nid: res.data![i].nid ?? 0,
              photo: res.data![i].photo ?? "",
              //  status: res.data![i].status ?? 0,
              religion: res.data![i].religion ?? "",
              gender: res.data![i].gender ?? "",
              latitude: res.data![i].latitude ?? "",
              longitude: res.data![i].longitude ?? "",
              divisionId: res.data![i].divisionId ?? -10,
              districtId: res.data![i].districtId ?? -10,
              upazilaId: res.data![i].upazilaId ?? -10,
              unionId: res.data![i].unionId ?? -10,
              wardId: res.data![i].wardNo ?? -10,
              userId: res.data![i].userId ?? -10,
              isSendBack: res.data![i].isSendBack,
              sendBackComments: res.data![i].sendBackReason,
              sendBackReason: res.data![i].sendBackReason,
              fatherOrHusbandName: res.data![i].fatherOrHusbandName ?? '',
              statusId: res.data![i].statusId ?? 0,
              otpVerified: res.data![i].otpVerified ?? 0,
              isQuestionAnswer: res.data![i].isQuestionAnswer ?? 0,
              isLocationMatch: res.data![i].isLocationMatch ?? 0,
              district: res.data![i].district ?? "",
              upazila: res.data![i].upazila ?? "",
              union: res.data![i].union ?? "",
              divisionName: res.data![i].district?.name ?? "",
              districtName: res.data![i].district?.bnName ?? "",
              upazilaName: res.data![i].upazila?.bnName ?? "",
              unionName: res.data![i].union?.bnName ?? "",
              junction: res.data![i].junction ?? '',
              // division: jsonEncode(res.data![i].division??""),
              // district: jsonEncode(res.data![i].district??""),
              // upazila: jsonEncode(res.data![i].upazila??""),
              // union: jsonEncode(res.data![i].union??""),
              createdBy: res.data![i].createdBy ?? "",
              updatedBy: res.data![i].updatedBy ?? "",
              deletedBy: res.data![i].deletedBy ?? "");
        }
        // }else{
        //   for(int i = 0; i<res.data!.length; i++){
        //     nonSelectedBeneficiaryList.add(res.data![i]);
        //     await BeneficiaryListTable().updateBeneficiary(
        //         id: res.data![i].id!,
        //         photo: res.data![i].photo??"",
        //         status: res.data![i].status??0,
        //         latitude: res.data![i].latitude??"",
        //         longitude: res.data![i].longitude??"",
        //         statusId: res.data![i].statusId??0,
        //         createdBy: res.data![i].createdBy??"",
        //         updatedBy: res.data![i].updatedBy??"",
        //         deletedBy: res.data![i].deletedBy??""
        //     );
        //   }
        // }
      } else {
        CustomSnackBar(message: "Failed to Fetch Data", isSuccess: false).show();
      }
      notifyListeners();
    } else {
      /// if offline then perform the following code
      final beneficiaries =
          await BeneficiaryListTable().fetchPaginatedBeneficiaries(1, 15, statusIdList, upazillaId: upazilaId ?? -10, unionId: unionId ?? -10);
      //final beneficiaries = await BeneficiaryListTable().fetchPaginatedBeneficiaries(pageNo, 15);
      //final single = await BeneficiaryListTable().getSingleBeneficiary(beneficiaryId: 5);
      //print(single);
      networkConnected = false;
      notifyListeners();
      if (beneficiaries.isNotEmpty) {
        nonSelectedBeneficiaryList = beneficiaries;
        notifyListeners();
      }
      print(beneficiaries);

      // final all = await BeneficiaryListTable().getAllData();
      // print(all.length);
    }

    print("nonSelectedBeneficiaryList.length ${nonSelectedBeneficiaryList.length}");
    notifyListeners();
  }

  clearNonSelectedLEBenfList() {
    nonSelectedBeneficiaryList.clear();
    notifyListeners();
  }

  BeneficiaryDetailsData? _beneficiaryDetailsData = BeneficiaryDetailsData();
  BeneficiaryDetailsData? get beneficiaryDetailsData => _beneficiaryDetailsData;
  bool isIDRefresh = false;

  Future<void> getBeneficiaryByID(int benfiD) async {
    _beneficiaryDetailsData = null;
    final res = await LeDashboardApi().getBeneficiaryDataByID(benfiD);
    if (res != null) {
      _beneficiaryDetailsData = res.data;
    }
    notifyListeners();
  }

  Future<void> selectBeneficiary({required int id, required int index}) async {
    final res = await LeDashboardApi().selectBeneficiary(beneficiaryId: id);
    if (res == "200") {
      removeBeneficiary(index: index);
      BeneficiaryListTable().updateBeneficiary(id: id, statusId: 1);
      getLeDashboard();
      notifyListeners();
      print("online");
    } else if (res == "300") {
      await BeneficiaryListTable().deleteSyncedBenf(id);
      CustomSnackBar(isSuccess: false, message: 'Already Selected').show();
    } else {
      BeneficiaryListTable().updateBeneficiary(id: id, statusId: 1);
      removeBeneficiary(index: index);
      getLeDashboard();
      notifyListeners();
      print("offline");
    }
  }

  void startCountdownTimer() {
    isTimerOn = true;
    countdown = 60;
    notifyListeners();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      countdown--;
      if (countdown == 0) {
        isTimerOn = false;
        t.cancel(); // Stop the timer when countdown reaches 0
      }
      notifyListeners();
    });
  }

  // void postLeAns({required int beneficiaryId, required List<LeAnsModel> ansList})async{
  //   isAnsSubmitted = false;
  //   notifyListeners();
  //   final res = await LeDashboardApi().leAnsQsnPost(beneficiaryId: beneficiaryId, ansList: ansList);
  //   if(res == "200"){
  //     isAnsSubmitted = true;
  //     notifyListeners();
  //   }
  // }

  Future<void> getLatrineImages({required int beneficiaryId}) async {
    final res = await LeDashboardApi().getLatrineImages(beneficiaryId: beneficiaryId);
    if (res != null) {
      latrineImageList = res.data!;
      notifyListeners();
    }
  }

  Future<void> storeImageUrlInFile({required int beneficiaryId, required OperationProvider op}) async {
    final latrineImgResponse = await LeDashboardApi().getLatrineImages(beneficiaryId: beneficiaryId);
    for (var element in latrineImgResponse!.data!) {
      if (element.stepId == 1) {
        final agreementFile = await op.convertUrlToFile(element.photoUrl!);
        await LatrineProgressTable().updateImage(
          beneficiaryId: beneficiaryId,
          photoStep1: agreementFile.path.toString(),
        );
      } else if (element.stepId == 2) {
        final twoPitsFile = await op.convertUrlToFile(element.photoUrl!);
        await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep2: twoPitsFile.path.toString());
      } else if (element.stepId == 3) {
        final interiorFile = await op.convertUrlToFile(element.photoUrl!);
        await LatrineProgressTable().updateImage(
          beneficiaryId: beneficiaryId,
          photoStep3: interiorFile.path.toString(),
        );
      } else if (element.stepId == 4) {
        final exteriorFile = await op.convertUrlToFile(element.photoUrl!);
        await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep4: exteriorFile.path.toString());
      } else if (element.stepId == 5) {
        final completeFile = await op.convertUrlToFile(element.photoUrl!);
        await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep5: completeFile.path.toString());
      }
    }
  }

  backUpImageFromLocal({required int beneficiaryId, required OperationProvider op}) async {
    final localImgData = await LatrineProgressTable().getSingleImage(beneficiaryId: beneficiaryId);
    if (localImgData != null) {
      if (localImgData.photoStep1sts == 'local') {
        final res = await LeDashboardApi().lePhotoSubmission(
          beneficiaryId: beneficiaryId,
          step1: localImgData.photoStep1,
        );
        if (res == '200') {
          await LatrineProgressTable().updateImage(
            beneficiaryId: beneficiaryId,
            photoStep1: '',
            photoStep1sts: 'sent',
          );
        }
      }
      if (localImgData.photoStep2sts == 'local') {
        final res = await LeDashboardApi().lePhotoSubmission(
          beneficiaryId: beneficiaryId,
          step2: localImgData.photoStep2,
        );
        if (res == '200') {
          await LatrineProgressTable().updateImage(
            beneficiaryId: beneficiaryId,
            photoStep1: '',
            photoStep1sts: 'sent',
          );
        }
      }
      if (localImgData.photoStep3sts == 'local') {
        final res = await LeDashboardApi().lePhotoSubmission(
          beneficiaryId: beneficiaryId,
          step3: localImgData.photoStep3,
        );
      }
    }
  }

  Future<void> updateImgFrmInternet({required int beneficiaryId, required OperationProvider op}) async {
    final latrineImgResponse = await LeDashboardApi().getLatrineImages(beneficiaryId: beneficiaryId);
    final res = await LatrineProgressTable().getSingleImage(beneficiaryId: beneficiaryId);
    if (latrineImgResponse?.data != null) {
      if (res != null) {
        for (var element in latrineImgResponse!.data!) {
          if (element.stepId == 1) {
            if (res.photoStep1sts == 'local') {
              log('agreementphoto already in local');
            } else {
              if (element.photoUrl != null) {
                final agreementFile = await op.convertUrlToFile(element.photoUrl!);
                await LatrineProgressTable().updateImage(
                  beneficiaryId: beneficiaryId,
                  photoStep1: agreementFile.path.toString(),
                  photoStep1sts: 'sent',
                );
              } else {
                await LatrineProgressTable().updateImage(
                  beneficiaryId: beneficiaryId,
                  photoStep1: res.photoStep1,
                  photoStep1sts: res.photoStep1sts,
                );
              }
            }
          } else if (element.stepId == 2) {
            if (res.photoStep2sts == 'local') {
              log('twopits already in local');
            } else {
              if (element.photoUrl != null) {
                final twoPitsFile = await op.convertUrlToFile(element.photoUrl!);
                await LatrineProgressTable().updateImage(
                  beneficiaryId: beneficiaryId,
                  photoStep2: twoPitsFile.path.toString(),
                  latitude2: element.latitude.toString(),
                  longitude2: element.longitude.toString(),
                  photoStep2sts: 'sent',
                );
              } else {
                await LatrineProgressTable().updateImage(
                  beneficiaryId: beneficiaryId,
                  photoStep2: res.photoStep2,
                  photoStep2sts: res.photoStep2sts,
                );
              }
            }

            //
          } else if (element.stepId == 3) {
            if (res.photoStep3sts == 'local') {
              log('interior already in local');
            } else {
              final interiorFile = await op.convertUrlToFile(element.photoUrl!);
              if (element.photoUrl != null) {
                await LatrineProgressTable().updateImage(
                  beneficiaryId: beneficiaryId,
                  photoStep3sts: 'sent',
                  latitude: element.latitude.toString(),
                  longitude: element.longitude.toString(),
                  photoStep3: interiorFile.path.toString(),
                );
              } else {
                await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep3: '', photoStep3sts: '');
              }
            }
          } else if (element.stepId == 4) {
            if (res.photoStep4 == 'local') {
              log('exterior already in local');
            } else {
              if (element.photoUrl != null) {
                final exteriorFile = await op.convertUrlToFile(element.photoUrl!);
                await LatrineProgressTable().updateImage(
                  beneficiaryId: beneficiaryId,
                  photoStep4: exteriorFile.path.toString(),
                  photoStep4sts: 'sent',
                );
              } else {
                await LatrineProgressTable().updateImage(
                  beneficiaryId: beneficiaryId,
                  photoStep4sts: res.photoStep4sts,
                  photoStep4: res.photoStep4,
                );
              }
            }

            //final exteriorFile = await op.convertUrlToFile(element.photoUrl!);
          } else if (element.stepId == 5) {
            if (res.photoStep5sts == 'local') {
              log('completefile already in local');
            } else {
              if (element.photoUrl != null) {
                final completeFile = await op.convertUrlToFile(element.photoUrl!);
                await LatrineProgressTable()
                    .updateImage(beneficiaryId: beneficiaryId, photoStep5sts: 'sent', photoStep5: completeFile.path.toString());
              } else {
                await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep5: res.photoStep5, photoStep5sts: res.photoStep5sts);
              }
            }

            //
          }
        }
      } else {
        for (var element in latrineImgResponse!.data!) {
          if (element.stepId == 1) {
            if (element.photoUrl != null) {
              final agreementFile = await op.convertUrlToFile(element.photoUrl!);
              await LatrineProgressTable()
                  .updateImage(beneficiaryId: beneficiaryId, photoStep1: agreementFile.path.toString(), photoStep1sts: 'sent');
            } else {
              await LatrineProgressTable().updateImage(
                beneficiaryId: beneficiaryId,
                photoStep1: '',
                photoStep1sts: '',
              );
            }
          } else if (element.stepId == 2) {
            if (element.photoUrl != null) {
              final twoPitsFile = await op.convertUrlToFile(element.photoUrl!);
              await LatrineProgressTable().updateImage(
                beneficiaryId: beneficiaryId,
                photoStep2: twoPitsFile.path.toString(),
                photoStep2sts: 'sent',
              );
            } else {
              await LatrineProgressTable().updateImage(
                beneficiaryId: beneficiaryId,
                photoStep2: '',
                photoStep2sts: '',
              );
            }

            //
          } else if (element.stepId == 3) {
            final interiorFile = await op.convertUrlToFile(element.photoUrl!);
            if (element.photoUrl != null) {
              await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep3sts: 'sent', photoStep3: interiorFile.path.toString());
            } else {
              await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep3: '', photoStep3sts: '');
            }
          } else if (element.stepId == 4) {
            if (element.photoUrl != null) {
              final exteriorFile = await op.convertUrlToFile(element.photoUrl!);
              await LatrineProgressTable().updateImage(
                beneficiaryId: beneficiaryId,
                photoStep4: exteriorFile.path.toString(),
                photoStep4sts: 'sent',
              );
            } else {
              await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep4sts: '', photoStep4: '');
            }

            //final exteriorFile = await op.convertUrlToFile(element.photoUrl!);
          } else if (element.stepId == 5) {
            if (element.photoUrl != null) {
              final completeFile = await op.convertUrlToFile(element.photoUrl!);
              await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep5sts: 'sent', photoStep5: completeFile.path.toString());
            } else {
              await LatrineProgressTable().updateImage(beneficiaryId: beneficiaryId, photoStep5: '', photoStep5sts: '');
            }

            //
          }
        }
      }
    }
    notifyListeners();
  }
}
