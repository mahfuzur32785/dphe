import 'dart:developer';
import 'dart:ffi';
import 'dart:ui';
import 'package:shimmer/shimmer.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:dphe/Data/models/common_models/camera_model.dart';
import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/api/le_dashboard_api/le_dashboard_api.dart';
import 'package:dphe/components/camera_widget/camera_capture.dart';
import 'package:dphe/components/camera_widget/camera_widget.dart';
import 'package:dphe/components/custom_appbar/custom_appbar_inner.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/offline_database/db_tables/le_tables/beneficiary_list_table.dart';
import 'package:dphe/offline_database/db_tables/le_tables/latrine_progress_table.dart';
import 'package:dphe/provider/le_providers/le_dashboard_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:dphe/utils/app_strings.dart';
import 'package:dphe/utils/common_functions.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../utils/asset_strings.dart';

class LatrineProgress extends StatefulWidget {
  final int benficiaryID;
  final BeneficiaryDetailsData beneficiary;
  const LatrineProgress({super.key, required this.benficiaryID, required this.beneficiary});

  @override
  State<LatrineProgress> createState() => _LatrineProgressState();
}

class _LatrineProgressState extends State<LatrineProgress> {
  String? latitude;
  String? longitude;
  String? latitude2;
  String? longitude2;
  bool locationPermission = false;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  List<File> imageList = [];
  List<int?> imageIndexList = [];
  bool pickedImage = false;
  late File imageFile;
  int currentImgIndex = 0;
  File? agreementFile;
  File? twoPitsFile;
  File? interiorFile;
  File? exteriorFile;
  File? completeFile;
  int? junctionSelectedOption;
  bool pageLoading = false;

  String agreementPath = "";
  String twoPitsPath = "";
  String interiorPath = "";
  String exteriorPath = "";
  String completePath = "";

  bool isAgreementImgLoading = false;
  bool isTwinPitImgLoading = false;
  bool isInteriorImgLoading = false;
  bool imgLoading = false;

  String agreementPathsts = "";
  String twoPitsPathsts = "";
  String interiorPathsts = "";
  String exteriorPathsts = "";
  String completePathsts = "";

  Uint8List? agreementFileUint8List;
  Uint8List? twoPitsFileUint8List;
  Uint8List? interiorFileUint8List;
  Uint8List? exteriorFileUint8List;
  Uint8List? completeFileUint8List;

  final ImagePicker picker = ImagePicker();
  bool isSubmitLoading = false;
  bool isBenfRefresh = false;
  Future<void> getBenficiaryData({bool isStart = false}) async {
    final provider = Provider.of<LeDashboardProvider>(context, listen: false);
    //final op = Provider.of<OperationProvider>(context, listen: false);
    // if (op.isConnected) {
    // setState(() {
    //   isBenfRefresh = true;
    // });

    if (interiorPathsts == 'local' || twoPitsPathsts == 'local') {
      return;
    } else {
      await provider.getBeneficiaryByID(widget.benficiaryID);
    }

    ///final recheckInternetConnection = await LeDashboardApi().recheckInternetConnection();
    //if (recheckInternetConnection) {

    // } else {
    //   //   setState(() {
    //   //   isBenfRefresh = false;
    //   // });
    //   return;
    // }
    // setState(() {
    //   isBenfRefresh = false;
    // });
    // } else {
    //   return;
    // }
  }

  getImageUrlInFile() async {
    final lep = Provider.of<LeDashboardProvider>(context, listen: false);
    final op = Provider.of<OperationProvider>(context, listen: false);
    //if (op.isConnected) {
    //log('network connected');
    //final recheckNetwork = await LeDashboardApi().recheckInternetConnection();
    // if (recheckNetwork) {
    await lep.updateImgFrmInternet(beneficiaryId: widget.benficiaryID, op: op);
    // } else {
    //   return;
    // }

    //await lep.storeImageUrlInFile(beneficiaryId: widget.beneficiary.id!, op: op);
    // } else {
    //   log('network disconnected');
    //   return;
    // }
  }

  dragrefreshData() async {
    final rnetwork = await LeDashboardApi().recheckInternetConnection();
    if (rnetwork) {
      await getBenficiaryData();

      await getImageUrlInFile();
    }
    await newgetImagePathFromLocalDB();
  }

  Future<void> newgetImagePathFromLocalDB() async {
    final res = await LatrineProgressTable().getSingleImage(beneficiaryId: widget.benficiaryID);
    if (res != null) {
      setState(() {
        agreementPath = res.photoStep1 ?? "";
        twoPitsPath = res.photoStep2 ?? "";
        interiorPath = res.photoStep3 ?? "";
        exteriorPath = res.photoStep4 ?? "";
        completePath = res.photoStep5 ?? "";
        agreementPathsts = res.photoStep1sts ?? "";
        twoPitsPathsts = res.photoStep2sts ?? "";
        interiorPathsts = res.photoStep3sts ?? "";
        exteriorPathsts = res.photoStep4sts ?? "";
        completePathsts = res.photoStep5sts ?? "";

        latitude = res.latitude;
        longitude = res.longitude;
        latitude2 = res.latitude2;
        longitude2 = res.longitude2;
      });
      log('local lat $latitude local lng $longitude');
    }
  }

  String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return ((bytes / math.pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  _getFromCamera({required int index, required OperationProvider op, required LeDashboardProvider leProvider}) async {
    XFile? pickedFile;

    if (index == 2) {
      var camModel = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(),
          ));
      if (camModel != null && camModel is CameraDataModel) {
        if (camModel.latitude != null && camModel.longitude != null && camModel.xpictureFile != null) {
          setState(() {
            latitude = null;
            longitude = null;
            pickedFile = camModel.xpictureFile;
            latitude = camModel.latitude.toString();
            longitude = camModel.longitude.toString();
          });
        } else if (camModel.latitude == null && camModel.longitude == null && camModel.xpictureFile != null) {
          CustomSnackBar(
                  message: 'Cannot Fetch Latitude or Longitude at this moment.Please Check your Internet connection or Check Location Settings',
                  isSuccess: false)
              .show();
        }

        log('updated lat lng $latitude-$longitude');
      } else {
        return;
        // if (latitude == null || longitude == null) {
        // CustomSnackBar(
        //         message: 'Cannot Fetch Latitude or Longitude at this moment.Please Check your Internet connection or Check Location Settings',
        //         isSuccess: false)
        //     .show();
        //}
      }
    } else if (index == 1) {
      var camModel = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(),
          ));
      if (camModel != null && camModel is CameraDataModel) {
        if (camModel.latitude != null && camModel.longitude != null && camModel.xpictureFile != null) {
          setState(() {
            latitude2 = null;
            longitude2 = null;
            pickedFile = camModel.xpictureFile;
            latitude2 = camModel.latitude.toString();
            longitude2 = camModel.longitude.toString();
          });
        } else if (camModel.latitude == null && camModel.longitude == null && camModel.xpictureFile != null) {
          CustomSnackBar(
            message: 'Cannot Fetch Latitude or Longitude at this moment.Please Check your Internet connection or Check Location Settings',
            isSuccess: false,
          ).show();
        }

        log('updated lat lng $latitude-$longitude');
      } else {
        // if (latitude == null || longitude == null) {
        return;
        //}
      }
    } else {
      var camModel = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaptureImage(),
          ));
      if (camModel != null && camModel is CameraDataModel) {
        setState(() {
          pickedFile = camModel.xpictureFile;
        });
      }
      // pickedFile = await picker.pickImage(
      //   source: ImageSource.camera,
      //   maxWidth: 1800,
      //   maxHeight: 1800,
      //   preferredCameraDevice: CameraDevice.rear,
      //   imageQuality: 60
      // );
    }
    // setState(() {
    //   isTwinPitImgLoading = true;
    // });
    if (pickedFile != null) {
      saveImage(pickedImage: pickedFile!, index: index, op: op, leProvider: leProvider);
    }
    // setState(() {
    //   isTwinPitImgLoading = false;
    // });
  }

  setSendBackJunction() async {
    junctionSelectedOption = null;
    final lep = Provider.of<LeDashboardProvider>(context, listen: false);
    final op = Provider.of<OperationProvider>(context, listen: false);
    if (op.isConnected) {
      final recheckNet = await LeDashboardApi().recheckInternetConnection();
      if (recheckNet) {
        final selectedJunction = lep.beneficiaryDetailsData?.junction;

        if (selectedJunction != null) {
          junctionSelectedOption = selectedJunction == 'Y'
              ? 0
              : selectedJunction == 'T'
                  ? 1
                  : null;
        } else {
          junctionSelectedOption = null;
        }
      } else {
        final selectedJunction = widget.beneficiary.junction;

        if (selectedJunction != null || selectedJunction != '') {
          junctionSelectedOption = selectedJunction == 'Y'
              ? 0
              : selectedJunction == 'T'
                  ? 1
                  : null;
        } else {
          junctionSelectedOption = null;
        }
      }
    } else {
      final selectedJunction = widget.beneficiary.junction;

      if (selectedJunction != null || selectedJunction != '') {
        junctionSelectedOption = selectedJunction == 'Y'
            ? 0
            : selectedJunction == 'T'
                ? 1
                : null;
      } else {
        junctionSelectedOption = null;
      }
    }
  }

  Future<void> saveImage({
    required XFile pickedImage,
    required int index,
    required OperationProvider op,
    required LeDashboardProvider leProvider,
  }) async {
    final imgByte = await op.getUint8ListFile(File(pickedImage.path));
    final appDir = await getApplicationDocumentsDirectory(); // Or any other directory you prefer
    final uniqueFileName = DateTime.now().microsecondsSinceEpoch;
    final savedImage = File('${appDir.path}/dphe/$uniqueFileName.jpg');

    //selectedChequeImg = File(pickedFile.path);

    // Create the folder if it doesn't exist
    final folder = Directory('${appDir.path}/dphe');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    // await compressedImg.writeAsBytes(await savedCompressedImg.readAsBytes());

    await savedImage.writeAsBytes(imgByte!);

    // You can now access the saved image using savedImage.path
    setState(() {
      isBenfRefresh = true;
      imageFile = File(savedImage.path);
      var imgSize = getFileSizeString(bytes: savedImage.lengthSync());
      log('img size $imgSize');
    });

    if (index == 0) {
      agreementFile = File(savedImage.path);

      if (op.isConnected) {
        final recheckNetwork = await LeDashboardApi().recheckInternetConnection();
        if (recheckNetwork) {
          final response = await LeDashboardApi().lePhotoSubmission(
            beneficiaryId: widget.benficiaryID,
            step1: agreementFile!.path.toString(),
          );
          if (response == '200') {
            await LatrineProgressTable().updateImage(
              beneficiaryId: widget.benficiaryID,
              photoStep1: agreementFile!.path.toString(),
              photoStep1sts: 'sent',
            );
          } else {
            //CustomSnackBar(message: "Failed To Connect to the Server, Please Try Again Later", isSuccess: false).show();
            debugPrint('Update Image into server failed');
          }

          await getImageUrlInFile();
          await getBenficiaryData();
        } else {
          await LatrineProgressTable().updateImage(
            beneficiaryId: widget.benficiaryID,
            photoStep1: agreementFile!.path.toString(),
            photoStep1sts: 'local',
          );
        }
      } else {
        await LatrineProgressTable().updateImage(
          beneficiaryId: widget.benficiaryID,
          photoStep1: agreementFile!.path.toString(),
          photoStep1sts: 'local',
        );
      }
    } else if (index == 1) {
      twoPitsFile = File(savedImage.path);
      if (op.isConnected) {
        final recheckNetwork = await LeDashboardApi().recheckInternetConnection();
        if (recheckNetwork) {
          final response = await LeDashboardApi().lePhotoSubmission(
            beneficiaryId: widget.benficiaryID,
            step2: twoPitsFile!.path.toString(),
            latitude2: latitude2,
            longitude2: longitude2,
          );
          if (response == '200') {
            await LatrineProgressTable().updateImage(
                beneficiaryId: widget.benficiaryID,
                photoStep2: twoPitsFile!.path.toString(),
                photoStep2sts: 'sent',
                latitude2: latitude2,
                longitude2: longitude2);
          }

          await getImageUrlInFile();

          await getBenficiaryData();
          fetchLatLngFromSendBack();
        } else {
          await LatrineProgressTable().updateImage(
              beneficiaryId: widget.benficiaryID,
              photoStep2: twoPitsFile!.path.toString(),
              photoStep2sts: 'local',
              latitude2: latitude2,
              longitude2: longitude2);
        }

        // fetchLatLngFromSendBack();
      } else {
        await LatrineProgressTable().updateImage(
            beneficiaryId: widget.benficiaryID,
            photoStep2: twoPitsFile!.path.toString(),
            photoStep2sts: 'local',
            latitude2: latitude2,
            longitude2: longitude2);
      }

      // await LatrineProgressTable().updateImage(beneficiaryId: widget.beneficiary.id, photoStep2: twoPitsFile!.path.toString());
      // getImagePathFromLocalDB();
      // await LeDashboardApi().lePhotoSubmission(beneficiaryId: widget.beneficiary.id!, step2: twoPitsFile!.path.toString()); // update to server
      // leProvider.getLatrineImages(beneficiaryId: widget.beneficiary.id!);
    } else if (index == 2) {
      interiorFile = File(savedImage.path);

      //getImagePathFromLocalDB();
      if (op.isConnected) {
        final recheckNetwork = await LeDashboardApi().recheckInternetConnection();
        if (recheckNetwork) {
          await LeDashboardApi().lePhotoSubmission(
              beneficiaryId: widget.beneficiary.id!,
              step3: interiorFile!.path.toString(),
              longitude: longitude, //longitude,//'91.1591462', //longitude,
              latitude: latitude //latitude//'23.2893392', //latitude,
              );
          await LatrineProgressTable().updateImage(
            beneficiaryId: widget.benficiaryID,
            latitude: latitude,
            longitude: longitude,
            photoStep3: interiorFile!.path.toString(),
            photoStep3sts: 'sent',
          );
          await getImageUrlInFile();

          await getBenficiaryData();

          fetchLatLngFromSendBack();
        } else {
          await LatrineProgressTable().updateImage(
              beneficiaryId: widget.benficiaryID,
              photoStep3: interiorFile!.path.toString(),
              latitude: latitude,
              longitude: longitude,
              photoStep3sts: 'local');
        }

        // if (res == '200') {

        //   await LatrineProgressTable().updateImage(
        //       beneficiaryId: widget.benficiaryID,
        //       photoStep3: interiorFile!.path.toString(),
        //       latitude: latitude,
        //       longitude: longitude,
        //       photoStep3sts: 'sent');
        //        await getImageUrlInFile();
        //   //await leProvider.getLatrineImages(beneficiaryId: widget.benficiaryID);
        //   newgetImagePathFromLocalDB();
        //   await getBenficiaryData();
        //   fetchLatLngFromSendBack();
        // } else if (res == '400') {
        //   await LatrineProgressTable().updateImage(
        //     beneficiaryId: widget.benficiaryID,
        //     photoStep3: '',
        //     latitude: '',
        //     longitude: '',
        //     photoStep3sts: '',
        //   );
        //   newgetImagePathFromLocalDB();
        //   await getBenficiaryData();
        //   fetchLatLngFromSendBack();
        // } else {
        //   // setState(() {
        //   //   latitude = widget.beneficiary.latitude.toString();
        //   //   longitude = widget.beneficiary.longitude.toString();
        //   // });
        //   await LatrineProgressTable().updateImage(
        //       beneficiaryId: widget.benficiaryID,
        //       photoStep3: interiorFile!.path.toString(),
        //       latitude: latitude,
        //       longitude: longitude,
        //       photoStep3sts: 'local');
        //   newgetImagePathFromLocalDB();
        // }
      } else {
        await LatrineProgressTable().updateImage(
            beneficiaryId: widget.benficiaryID,
            photoStep3: interiorFile!.path.toString(),
            latitude: latitude,
            longitude: longitude,
            photoStep3sts: 'local');
      }

      // getLocation();
    } else if (index == 3) {
      exteriorFile = File(savedImage.path);

      //getImagePathFromLocalDB();
      if (op.isConnected) {
        final recheckNetwork = await LeDashboardApi().recheckInternetConnection();
        if (recheckNetwork) {
          await LeDashboardApi().lePhotoSubmission(
            beneficiaryId: widget.benficiaryID,
            step4: exteriorFile!.path.toString(),
          ); // update to server

          await LatrineProgressTable().updateImage(
            beneficiaryId: widget.benficiaryID,
            photoStep4: exteriorFile!.path.toString(),
            photoStep4sts: 'sent',
          );

          await getImageUrlInFile();

          await getBenficiaryData();
        } else {
          await LatrineProgressTable().updateImage(
            beneficiaryId: widget.benficiaryID,
            photoStep4: exteriorFile!.path.toString(),
            photoStep4sts: 'local',
          );
        }
      } else {
        await LatrineProgressTable().updateImage(
          beneficiaryId: widget.benficiaryID,
          photoStep4: exteriorFile!.path.toString(),
          photoStep4sts: 'local',
        );
      }
    } else if (index == 4) {
      completeFile = File(savedImage.path);

      if (op.isConnected) {
        final recheckNetwork = await LeDashboardApi().recheckInternetConnection();
        if (recheckNetwork) {
          await LeDashboardApi().lePhotoSubmission(
            beneficiaryId: widget.benficiaryID,
            step5: completeFile!.path.toString(),
          );

          await LatrineProgressTable().updateImage(
            beneficiaryId: widget.benficiaryID,
            photoStep5: completeFile!.path.toString(),
            photoStep5sts: 'sent',
          );

          await getImageUrlInFile();

          await getBenficiaryData();
        } else {
          await LatrineProgressTable().updateImage(
            beneficiaryId: widget.benficiaryID,
            photoStep5: completeFile!.path.toString(),
            photoStep5sts: 'local',
          );
        }
      } else {
        await LatrineProgressTable().updateImage(
          beneficiaryId: widget.benficiaryID,
          photoStep5: completeFile!.path.toString(),
          photoStep5sts: 'local',
        );
      }
      // getImagePathFromLocalDB();
      // update to server
    }
    await newgetImagePathFromLocalDB();
    setState(() {
      isBenfRefresh = false;
    });
  }

  Future<void> requestPermission() async {
    //LocationPermission permission = await Geolocator.requestPermission();
    await Geolocator.requestPermission();
    await handlePermissions();
  }

  Future<bool> handlePermissions() async {
    //bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) Navigator.of(context).pop();
        if (context.mounted) Provider.of<LeDashboardProvider>(context, listen: false).setLocationPermission(permission: false);
        return false;
      }
    } else if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      //setState(() {
      //locationPermission = true;
      if (context.mounted) Provider.of<LeDashboardProvider>(context, listen: false).setLocationPermission(permission: true);

      //});
    }

    return true;
  }

  fetchLatLngFromSendBack() {
    final lep = Provider.of<LeDashboardProvider>(context, listen: false);
    final op = Provider.of<OperationProvider>(context, listen: false);
    var _latitude = widget.beneficiary.latitude;
    var _longitude = widget.beneficiary.longitude;
    var _latitude2 = widget.beneficiary.pitLatitude;
    var _longitude2 = widget.beneficiary.pitLongitude;
    if (widget.beneficiary.isSendBack == 1) {
      print('cur lat $_latitude - $_longitude');
      if (latitude == "" || longitude == "") {
        setState(() {
          latitude = _latitude.toString();
          longitude = _longitude.toString();
        });
      }
      if (latitude2 == "" || longitude2 == "") {
        setState(() {
          latitude2 = _latitude2.toString();
          longitude2 = _longitude2.toString();
        });
      }
    } else {
      var _nlatitude = lep.beneficiaryDetailsData?.latitude;
      var _nlongitude = lep.beneficiaryDetailsData?.longitude;
      var _nlatitude2 = lep.beneficiaryDetailsData?.pitLatitude;
      var _nlongitude2 = lep.beneficiaryDetailsData?.pitLongitude;
      if (latitude == null || longitude == null) {
        setState(() {
          latitude = _nlatitude.toString();
          longitude = _nlongitude.toString();
        });
      }
      if (latitude2 == null || longitude2 == null) {
        setState(() {
          latitude2 = _nlatitude2.toString();
          longitude2 = _nlongitude2.toString();
        });
      }
    }
  }

  pageInit() async {
    setState(() {
      pageLoading = true;
    });
    final isNetworkOn = await LeDashboardApi().recheckInternetConnection();
    if (isNetworkOn) {
      await getImageUrlInFile();
      await getBenficiaryData();
    }

    await newgetImagePathFromLocalDB();

    fetchLatLngFromSendBack();
    requestPermission();
    handlePermissions();

    await setSendBackJunction();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<LeDashboardProvider>(context, listen: false).getLatrineImages(beneficiaryId: widget.beneficiary.id!);
    // });
    //newgetImagePathFromLocalDB();

    setState(() {
      pageLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageInit();
  }

  @override
  Widget build(BuildContext context) {
    // getImageUrlInFile();
    return Consumer2<LeDashboardProvider, OperationProvider>(
      builder: (context, le, op, child) {
        return Scaffold(
          appBar: CustomAppbarInner(
            title: "Send to Verify",
            isLoading: isBenfRefresh,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await dragrefreshData();
              // await getBenficiaryData();

              // await newgetImagePathFromLocalDB();
              // await getImageUrlInFile();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: pageLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isBenfRefresh
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    child: Container(
                                      //height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: Colors.grey,
                                          )),
                                      child: Column(
                                        children: [
                                          Container(
                                            //width: double.infinity,
                                            height: 12.0,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 8.0),
                                          Container(
                                            //width: double.infinity,
                                            height: 12.0,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            //width: double.infinity,
                                            height: 12.0,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 8.0),
                                          Container(
                                            width: double.infinity,
                                            height: 12.0,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 12.0,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 8.0),
                                          Container(
                                            width: double.infinity,
                                            height: 12.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    enabled: true,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: beneficiaryInfoCard(beneficiary: le.beneficiaryDetailsData, op: op),
                                ),
                          newImgWidgetTile(
                              title: "পরিবার প্রধানের স্বাক্ষরিত চুক্তিপত্রের ছবি", //"স্বাক্ষরিত চুক্তি পত্রের ছবি",//"চুক্তির একটি ছবি তুলুন",
                              index: 0,
                              imageFl: agreementFile,
                              imagePath: agreementPath,
                              op: op,
                              leProvider: le,
                              imgSts: agreementPathsts),
                          const SizedBox(
                            height: 10,
                          ),
                          newImgWidgetTile(
                              title: "দুই পিট ও জাংশন সহ একটি ছবি",
                              index: 1,
                              imageFl: twoPitsFile,
                              imagePath: twoPitsPath,
                              op: op,
                              leProvider: le,
                              imgSts: twoPitsPathsts),
                          const SizedBox(
                            height: 10,
                          ),
                          newImgWidgetTile(
                              title: "ল্যাট্রিনের দরজায় দাঁড়িয়ে ল্যাট্রিনের ভিতরের প্যান ও পানির ট্যাংকের ছবি",
                              index: 2,
                              imageFl: interiorFile,
                              imagePath: interiorPath,
                              op: op,
                              leProvider: le,
                              imgSts: interiorPathsts),
                          const SizedBox(
                            height: 10,
                          ),
                          newImgWidgetTile(
                              title: "পরিবারের একজন সদস্যের সাথে টুইনপিট ল্যাট্রিনের ছবি ",
                              index: 3,
                              imageFl: exteriorFile,
                              imagePath: exteriorPath ?? "",
                              op: op,
                              leProvider: le,
                              imgSts: exteriorPathsts),
                          const SizedBox(
                            height: 10,
                          ),
                          newImgWidgetTile(
                              title: "হস্তান্তর সার্টিফিকেটের ছবি",
                              index: 4,
                              imageFl: completeFile,
                              imagePath: completePath ?? "",
                              op: op,
                              leProvider: le,
                              imgSts: completePathsts),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text('এই ল্যাট্রিনে কোন জাংশনটি ব্যাবহার করেছেন?'),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 0,
                                    groupValue: junctionSelectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        junctionSelectedOption = value;
                                      });
                                    },
                                  ),
                                  Text('Y জাংশন'),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: junctionSelectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        junctionSelectedOption = value;
                                      });
                                    },
                                  ),
                                  Text('T জাংশন'),
                                ],
                              ),
                            ],
                          ),
                          isSubmitLoading
                              ? Center(child: CircularProgressIndicator())
                              : CustomButtonRounded(
                                  title: AppStrings.submit,
                                  bgColor:
                                      completePath.isNotEmpty || Provider.of<LeDashboardProvider>(context, listen: false).latrineImageList.length >= 5
                                          ? MyColors.primaryColor
                                          : const Color.fromRGBO(150, 220, 255, 0.698),
                                  onPress: () async {
                                    if (op.isConnected) {
                                      setState(() {
                                        isSubmitLoading = true;
                                      });
                                      final recheckNetwork = await LeDashboardApi().recheckInternetConnection();
                                      if (recheckNetwork) {
                                        if (junctionSelectedOption != null) {
                                          await newSubmitImage(le, op, junctionSelectedOption!);
                                          setState(() {
                                            isSubmitLoading = false;
                                          });
                                        } else {
                                          CustomSnackBar(message: "জাংশন সম্পর্কিত প্রশ্নের উত্তর দিন", isSuccess: false).show();
                                        }
                                      } else {
                                        setState(() {
                                          isSubmitLoading = false;
                                        });
                                        CustomSnackBar(message: "আপনার নেটওয়ার্ক সংযোগ ধীর", isSuccess: false).show();
                                      }
                                    } else {
                                      CustomSnackBar(message: "ইন্টারনেট এর সাথে সংযুক্ত হন!", isSuccess: false).show();
                                    }
                                    setState(() {
                                      isSubmitLoading = false;
                                    });
                                  }
                                  //   //checkConnectivity();
                                  //   if (widget.beneficiary.isSendBack == 1) {
                                  //     if (le.latrineImageList.length == 5) {
                                  //       if (op.isConnected == true) {
                                  //         if (agreementPath.isNotEmpty ||
                                  //             twoPitsPath.isNotEmpty ||
                                  //             interiorPath.isNotEmpty ||
                                  //             exteriorPath.isNotEmpty ||
                                  //             completePath.isNotEmpty) {
                                  //           if (junctionSelectedOption != null) {
                                  //             if (latitude == null || longitude == null) {
                                  //               CustomSnackBar(message: "৩ নং ছবি টি পুনরায় তুলুন", isSuccess: false).show();
                                  //             } else {
                                  //               setState(() {
                                  //                 isSubmitLoading = true;
                                  //               });
                                  //               await submitWithImage(le, op, junctionSelectedOption!);
                                  //               setState(() {
                                  //                 isSubmitLoading = false;
                                  //               });
                                  //             }
                                  //           } else {
                                  //             CustomSnackBar(message: "জাংশন সম্পর্কিত প্রশ্নের উত্তর দিন", isSuccess: false).show();
                                  //           }
                                  //         }
                                  //         // final constructionRes = await LeDashboardApi().constructionComplete(beneficiaryId: widget.beneficiary.id!);
                                  //         // if (constructionRes == "200") {
                                  //         //   leprovider.nonSelectedBeneficiaryList.clear();
                                  //         //   leprovider.getNonSelectedBeneficiaryList(
                                  //         //     statusIdList: [10],
                                  //         //     // rows: 10,
                                  //         //     //upazilaId: -10,
                                  //         //     // unionId: -10,
                                  //         //     //pageNo: 1,
                                  //         //   );
                                  //         //   leprovider.getLeDashboard();
                                  //         //   await BeneficiaryListTable()
                                  //         //       .updateBeneficiary(id: widget.beneficiary.id!, statusId: 11); // bibechonadhin status id is 11
                                  //         //       setState(() {
                                  //         //   isSubmitLoading = false;
                                  //         // });
                                  //         //    setState(() {
                                  //         //   isSubmitLoading = false;
                                  //         // });
                                  //         //   CustomSnackBar(message: "সফলভাবে ভেরিফিকেশনের জন্য সাবমিট করা হয়েছে", isSuccess: true).show();
                                  //         //   if (context.mounted) {
                                  //         //     Navigator.of(context).pop();
                                  //         //   }
                                  //         // }
                                  //       } else {
                                  //         setState(() {
                                  //           isSubmitLoading = false;
                                  //         });
                                  //         CustomSnackBar(message: "ইন্টারনেট এর সাথে সংযুক্ত হন!", isSuccess: false).show();
                                  //       }
                                  //     } else if (agreementPath.isNotEmpty ||
                                  //         twoPitsPath.isNotEmpty ||
                                  //         interiorPath.isNotEmpty ||
                                  //         exteriorPath.isNotEmpty ||
                                  //         completePath.isNotEmpty) {
                                  //       if (junctionSelectedOption != null) {
                                  //         if (latitude == null || longitude == null) {
                                  //           CustomSnackBar(message: "৩ নং ছবি টি পুনরায় তুলুন", isSuccess: false).show();
                                  //         } else {
                                  //           setState(() {
                                  //             isSubmitLoading = true;
                                  //           });
                                  //           await submitWithImage(le, op, junctionSelectedOption!);
                                  //           setState(() {
                                  //             isSubmitLoading = false;
                                  //           });
                                  //         }
                                  //       } else {
                                  //         CustomSnackBar(message: "জাংশন সম্পর্কিত প্রশ্নের উত্তর দিন", isSuccess: false).show();
                                  //       }
                                  //     }
                                  //   } else {
                                  //     if (completePath.isNotEmpty || le.latrineImageList.length >= 5) {
                                  //       if (op.isConnected == true) {
                                  //         if (junctionSelectedOption != null) {
                                  //           setState(() {
                                  //             isSubmitLoading = true;
                                  //           });
                                  //           await submitWithImage(le, op, junctionSelectedOption!);
                                  //           setState(() {
                                  //             isSubmitLoading = false;
                                  //           });
                                  //         } else {
                                  //           CustomSnackBar(message: "জাংশন সম্পর্কিত প্রশ্নের উত্তর দিন", isSuccess: false).show();
                                  //         }
                                  //         //await submitWithImage(leprovider, op);
                                  //       } else {
                                  //         setState(() {
                                  //           isSubmitLoading = false;
                                  //         });
                                  //         CustomSnackBar(message: "ইন্টারনেট এর সাথে সংযুক্ত হন!", isSuccess: false).show();
                                  //       }
                                  //     } else {
                                  //       setState(() {
                                  //         isSubmitLoading = false;
                                  //       });
                                  //       CustomSnackBar(message: "আগে সবগুলা ছবি তুলুন", isSuccess: false).show();
                                  //     }
                                  //     setState(() {
                                  //       isSubmitLoading = false;
                                  //     });
                                  //     setState(() {
                                  //       junctionSelectedOption = null;
                                  //     });
                                  //   }
                                  // },
                                  ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> submitWithImage(LeDashboardProvider leDashboardProvider, OperationProvider op, int junction) async {
    if (agreementPathsts == 'sent' &&
        twoPitsPathsts == 'sent' &&
        interiorPathsts == 'sent' &&
        exteriorPathsts == 'sent' &&
        completePathsts == 'sent') {
      final constructionRes = await LeDashboardApi().constructionComplete(beneficiaryId: widget.beneficiary.id!, junction: junction == 0 ? "Y" : "T");
      if (constructionRes == "200") {
        leDashboardProvider.lePaginatedRefresh();
        leDashboardProvider.fetchNonSelectedPaginatedLeBenf(statusIdList: [10], op: op);

        leDashboardProvider.getLeDashboard();
        await LatrineProgressTable().deleteSyncedLatrineProgressImg(beneficiaryId: widget.benficiaryID);
        await BeneficiaryListTable().updateBeneficiary(id: widget.benficiaryID, statusId: 11); // bibechonadhin status id is 11
        CustomSnackBar(message: "সফলভাবে ভেরিফিকেশনের জন্য সাবমিট করা হয়েছে", isSuccess: true).show(); //Successfully submitted for verification
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
      setState(() {
        isSubmitLoading = false;
      });
    } else {
      final res = await LeDashboardApi().lePhotoSubmission(
        beneficiaryId: widget.beneficiary.id!,
        latitude: latitude, //lat
        longitude: longitude,
        latitude2: latitude2,
        longitude2: longitude2,
        step1: (agreementPathsts == 'local') ? agreementPath : null,
        step2: (twoPitsPathsts == 'local') ? twoPitsPath : null,
        step3: (interiorPathsts == 'local') ? interiorPath : null,
        step4: (exteriorPathsts == 'local') ? exteriorPath : null,
        step5: (completePathsts == 'local') ? completePath : null,
      );
      if (res == "200") {
        final constructionRes =
            await LeDashboardApi().constructionComplete(beneficiaryId: widget.beneficiary.id!, junction: junction == 0 ? "Y" : "T");
        if (constructionRes == "200") {
          leDashboardProvider.lePaginatedRefresh();
          leDashboardProvider.fetchNonSelectedPaginatedLeBenf(statusIdList: [10], op: op);

          leDashboardProvider.getLeDashboard();
          await LatrineProgressTable().deleteSyncedLatrineProgressImg(beneficiaryId: widget.benficiaryID);
          await BeneficiaryListTable().updateBeneficiary(id: widget.benficiaryID, statusId: 11); // bibechonadhin status id is 11
          CustomSnackBar(message: "সফলভাবে ভেরিফিকেশনের জন্য সাবমিট করা হয়েছে", isSuccess: true).show(); //Successfully submitted for verification
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
        setState(() {
          isSubmitLoading = false;
        });
      } else {
        //CustomSnackBar(message: "Some", isSuccess: false).show();
        setState(() {
          isSubmitLoading = false;
        });
      }
    }

    setState(() {
      isSubmitLoading = false;
    });
  }

  Future<void> newSubmitImage(LeDashboardProvider leDashboardProvider, OperationProvider op, int junction) async {
    await newgetImagePathFromLocalDB();
    if (agreementPathsts.isEmpty) {
      CustomSnackBar(message: "1 নং ছবি টি পুনরায় তুলুন", isSuccess: false).show();
    } else if (twoPitsPathsts.isEmpty) {
      CustomSnackBar(message: "2 নং ছবি টি পুনরায় তুলুন", isSuccess: false).show();
    } else if (interiorPathsts.isEmpty || latitude == null || longitude == null) {
      CustomSnackBar(message: "3 নং ছবি টি পুনরায় তুলুন", isSuccess: false).show();
    } else if (exteriorPathsts.isEmpty) {
      CustomSnackBar(message: "4 নং ছবি টি পুনরায় তুলুন", isSuccess: false).show();
    } else if (completePathsts.isEmpty) {
      CustomSnackBar(message: "5 নং ছবি টি পুনরায় তুলুন", isSuccess: false).show();
    } else if (junctionSelectedOption == null) {
      CustomSnackBar(message: "জাংশন সম্পর্কিত প্রশ্নের উত্তর দিন", isSuccess: false).show();
    } else {
      await submitWithImage(leDashboardProvider, op, junction);
    }
  }

  Widget titledCamera(
      {required String title,
      required int index,
      File? imageFl,
      required String imagePath,
      required OperationProvider op,
      required LeDashboardProvider leProvider}) {
    return Consumer<LeDashboardProvider>(builder: (context, controller, child) {
      return Row(
        children: [
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: MyTextStyle.primaryLight(fontSize: 14),
                  ),
                  if (index == 2) ...[
                    widget.beneficiary.isSendBack == 1
                        ? (widget.beneficiary.latitude != null && widget.beneficiary.longitude != null)
                            ? Text(
                                "Latitude : ${widget.beneficiary.latitude}\nLongitude : ${widget.beneficiary.longitude}",
                                style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                              )
                            : Text(
                                "Latitude : ${latitude ?? ''}\nLongitude : ${longitude ?? ''}",
                                style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                              )
                        : Text(
                            "Latitude : ${latitude ?? ''}\nLongitude : ${longitude ?? ''}",
                            style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                          ),
                  ]
                ],
              )),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                op.isConnected && controller.latrineImageList.length > index
                    ? Container(
                        // online image
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: MyColors.customGrey),
                            borderRadius: BorderRadius.circular(7),
                            image: (controller.latrineImageList.length > index)
                                ? imageFl != null
                                    ? DecorationImage(image: FileImage(imageFl), fit: BoxFit.cover)
                                    : imagePath.isNotEmpty
                                        ? DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover)
                                        : DecorationImage(
                                            image: NetworkImage(
                                              controller.latrineImageList[index].photoUrl!,
                                            ),
                                            fit: BoxFit.cover)
                                : null),

                        // child: imageList.length>index?
                        // imageList[index].toString().isNotEmpty?  Image.file(imageList[index], fit: BoxFit.fill,): Image.asset(AssetStrings.tankImage)
                        // :const SizedBox(),
                        //child: controller.latrineImageList.length>index? Image.network(controller.latrineImageList[index].photoUrl!, fit: BoxFit.fill,):const SizedBox(),
                        //working
                        // child: controller.latrineImageList.length > index
                        //     ? Image.network(
                        //         controller.latrineImageList[index].photoUrl!,
                        //         fit: BoxFit.fill,
                        //         // placeholder: (context, url) => Icon(Icons.image),
                        //         // errorWidget: (context, url, error) => Icon(Icons.broken_image),
                        //       )
                        //     : const SizedBox(),
                      )
                    : Container(
                        height: 120, // offline image container
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: MyColors.customGrey),
                            borderRadius: BorderRadius.circular(7),
                            image: imageFl != null
                                ? DecorationImage(image: FileImage(imageFl), fit: BoxFit.cover)
                                : imagePath.isNotEmpty
                                    ? DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover)
                                    : null),
                        // child: imageList.length>index?
                        // imageList[index].toString().isNotEmpty?  Image.file(imageList[index], fit: BoxFit.fill,): Image.asset(AssetStrings.tankImage)
                        // :const SizedBox(),
                        // child: imageFl != null
                        //     ? Image.file(
                        //         imageFl,
                        //         fit: BoxFit.fill,
                        //       )
                        //     : imagePath.isNotEmpty
                        //         ? Image.file(
                        //             File(imagePath),
                        //             fit: BoxFit.fill,
                        //           )
                        //         : const SizedBox(),
                      ),
                InkWell(
                    onTap: () async {
                      log('img index ${imageIndexList.length}');
                      var isServiceEnabled = await op.checkLocationServiceStatus();

                      if (isServiceEnabled) {
                        if (controller.isLocationPermissionEnabled == true) {
                          if (imageIndexList.length >= index) {
                            //if(imagePath.isNotEmpty){
                            await _getFromCamera(index: index, op: op, leProvider: leProvider);
                          } else {
                            CustomSnackBar(message: "অনুগ্রহ করে আগের ধাপটি সম্পন্ন করুন", isSuccess: false).show();
                          }
                        } else {
                          Geolocator.requestPermission();
                          CustomSnackBar(message: "অনুগ্রহ করে আগে লোকেশন পারমিশন দিন", isSuccess: false).show();
                        }
                      } else {
                        Geolocator.openLocationSettings();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (controller.latrineImageList.length > index) && (controller.latrineImageList[index].photoUrl != null)
                            ? Image.asset(
                                AssetStrings.checkIcon,
                                height: 30,
                              )
                            : SizedBox.shrink(),
                        Image.asset(
                          AssetStrings.cameraIcon, // controller.latrineImageList[index].photoUrl != null ?
                          height: 30,
                        ),
                      ],
                    )),

                // Positioned(
                //   right: -10,
                //     top: -10,
                //     child: IconButton(onPressed: (){
                //       setState(() {
                //         //imageList.removeAt(index);
                //         //imageFl.path;
                //         imageFl = null;
                //       });
                //
                //     }, icon: Icon(Icons.clear, color: Colors.red,)))
              ],
            ),
          )
        ],
      );
    });
  }

  //newImgWidgetTile
  Widget newImgWidgetTile(
      {required String title,
      required int index,
      File? imageFl,
      required String imagePath,
      required OperationProvider op,
      required LeDashboardProvider leProvider,
      required String imgSts}) {
    return Consumer<LeDashboardProvider>(builder: (context, controller, child) {
      return Row(
        children: [
          op.isConnected
              ? Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: MyTextStyle.primaryLight(fontSize: 14),
                      ),
                      if (index == 2) ...[
                        widget.beneficiary.isSendBack == 1
                            ? (latitude != null && longitude != null)
                                ? (latitude != '' && longitude != '')
                                    ? Text(
                                        "Latitude : $latitude \nLongitude : $longitude",
                                        style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                      )
                                    : (leProvider.beneficiaryDetailsData?.latitude != null && leProvider.beneficiaryDetailsData?.longitude != null)
                                        ? Text(
                                            "Latitude : ${leProvider.beneficiaryDetailsData!.latitude}\nLongitude : ${leProvider.beneficiaryDetailsData!.longitude}",
                                            style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                          )
                                        : Text(
                                            "Latitude : ${latitude ?? ''} \nLongitude : ${longitude ?? ''}",
                                            style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                          )
                                : Text(
                                    "Latitude : ${latitude ?? ''}\nLongitude : ${longitude ?? ''}",
                                    style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                  )
                            : Text(
                                "Latitude : ${latitude ?? ''}\nLongitude : ${longitude ?? ''}",
                                style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                              ),
                      ] else if (index == 1) ...[
                        widget.beneficiary.isSendBack == 1
                            ? (latitude2 != null && longitude2 != null)
                                ? (latitude2 != '' && longitude2 != '')
                                    ? Text(
                                        "Latitude : $latitude2 \nLongitude : $longitude2",
                                        style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                      )
                                    : (leProvider.beneficiaryDetailsData?.pitLatitude != null &&
                                            leProvider.beneficiaryDetailsData?.pitLongitude != null)
                                        ? Text(
                                            "Latitude : ${leProvider.beneficiaryDetailsData!.pitLatitude}\nLongitude : ${leProvider.beneficiaryDetailsData!.pitLongitude}",
                                            style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                          )
                                        : Text(
                                            "Latitude : ${latitude2 ?? ''} \nLongitude : ${longitude2 ?? ''}",
                                            style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                          )
                                : Text(
                                    "Latitude : ${latitude2 ?? ''}\nLongitude : ${longitude2 ?? ''}",
                                    style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                  )
                            : Text(
                                "Latitude : ${latitude2 ?? ''}\nLongitude : ${longitude2 ?? ''}",
                                style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                              ),
                      ]
                    ],
                  ))
              : Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: MyTextStyle.primaryLight(fontSize: 14),
                      ),
                      if (index == 2) ...[
                        widget.beneficiary.isSendBack == 1
                            ? (latitude != null && longitude != null)
                                ? (latitude == '' && longitude == '')
                                    ? Text(
                                        "Latitude : ${widget.beneficiary.latitude ?? ''} \nLongitude : ${widget.beneficiary.longitude}",
                                        style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                      )
                                    : Text(
                                        "Latitude : ${latitude ?? ''} \nLongitude : $longitude",
                                        style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                      )
                                : Text(
                                    "Latitude : ${widget.beneficiary.latitude}\nLongitude : ${widget.beneficiary.longitude}",
                                    style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                  )
                            : Text(
                                "Latitude : ${latitude ?? ''} \nLongitude : $longitude",
                                style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                              )
                        // widget.beneficiary.isSendBack == 1
                        //     ? (widget.beneficiary.latitude != null && widget.beneficiary.longitude != null)
                        //         ? (latitude != widget.beneficiary.latitude && longitude != widget.beneficiary.longitude)
                        //             ? Text(
                        //                 "Latitude : ${latitude ?? ''}\nLongitude : ${longitude ?? ''}",
                        //                 style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                        //               )

                        //         : Text(
                        //             "Latitude : ${latitude ?? ''}\nLongitude : ${longitude ?? ''}",
                        //             style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                        //           )
                        //     : Text(
                        //         "Latitude : ${latitude ?? ''}\nLongitude : ${longitude ?? ''}",
                        //         style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                        //       ),
                      ] else if (index == 1) ...[
                        widget.beneficiary.isSendBack == 1
                            ? (latitude2 != null && longitude2 != null)
                                ? (latitude2 == '' && longitude2 == '')
                                    ? Text(
                                        "Latitude : ${widget.beneficiary.pitLatitude ?? ''} \nLongitude : ${widget.beneficiary.pitLongitude}",
                                        style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                      )
                                    : Text(
                                        "Latitude : ${latitude2 ?? ''} \nLongitude : $longitude2",
                                        style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                      )
                                : Text(
                                    "Latitude : ${widget.beneficiary.pitLatitude}\nLongitude : ${widget.beneficiary.pitLongitude}",
                                    style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                                  )
                            : Text(
                                "Latitude : ${latitude2 ?? ''} \nLongitude : $longitude2",
                                style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                              )
                      ]
                    ],
                  )),
          const SizedBox(
            width: 5,
          ),
          op.isConnected
              ? Expanded(
                  flex: 5,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // controller.latrineImageList.length > index
                      //     ?
                      //     Container(
                      //         // online image
                      //         height: 120,
                      //         width: double.infinity,
                      //         decoration: BoxDecoration(
                      //             border: Border.all(color: MyColors.customGrey),
                      //             borderRadius: BorderRadius.circular(7),
                      //             image: (controller.latrineImageList.length > index)
                      //                 ? imagePath.isNotEmpty
                      //                     ? DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover)
                      //                     : DecorationImage(
                      //                         image: NetworkImage(
                      //                           controller.latrineImageList[index].photoUrl!,
                      //                         ),
                      //                         fit: BoxFit.cover)
                      //                 : null),
                      //       )
                      //     :
                      Container(
                        height: 120, // offline image container
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: MyColors.customGrey),
                            borderRadius: BorderRadius.circular(7),
                            image: imagePath.isNotEmpty ? DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover) : null),
                      ),
                      InkWell(
                        onTap: () async {
                          log('img index ${imageIndexList.length}');
                          var isServiceEnabled = await op.checkLocationServiceStatus();

                          if (isServiceEnabled) {
                            if (controller.isLocationPermissionEnabled == true) {
                              var locationAccuracy = await Geolocator.getLocationAccuracy();
                              if (locationAccuracy == LocationAccuracyStatus.reduced) {
                                Geolocator.requestPermission();
                              } else{
                                if (index == 1 && agreementPath.isEmpty) {
                                  CustomSnackBar(message: "অনুগ্রহ করে আগের ধাপটি সম্পন্ন করুন", isSuccess: false).show();
                                } else if (index == 2 && (agreementPath.isEmpty || twoPitsPath.isEmpty)) {
                                  CustomSnackBar(message: "অনুগ্রহ করে আগের ধাপটি সম্পন্ন করুন", isSuccess: false).show();
                                } else if (index == 3 && (agreementPath.isEmpty || twoPitsPath.isEmpty || interiorPath.isEmpty)) {
                                  //
                                  CustomSnackBar(message: "অনুগ্রহ করে আগের ধাপটি সম্পন্ন করুন", isSuccess: false).show();
                                } else if (index == 4 &&
                                    (agreementPath.isEmpty || twoPitsPath.isEmpty || interiorPath.isEmpty || exteriorPath.isEmpty)) {
                                  CustomSnackBar(message: "অনুগ্রহ করে আগের ধাপটি সম্পন্ন করুন", isSuccess: false).show();
                                } else {
                                  //print('isTwinPitImgLoading $isTwinPitImgLoading');
                                  await _getFromCamera(index: index, op: op, leProvider: leProvider);
                                }
                              }
                            } else {
                              Geolocator.requestPermission();
                              CustomSnackBar(message: "অনুগ্রহ করে আগে লোকেশন পারমিশন দিন", isSuccess: false).show();
                            }
                          } else {
                            Geolocator.openLocationSettings();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //(controller.latrineImageList.length > index) && (controller.latrineImageList[index].photoUrl != null)
                            imgSts == 'sent'
                                ? Image.asset(
                                    AssetStrings.checkIcon,
                                    height: 30,
                                  )
                                : SizedBox.shrink(),
                            Image.asset(
                              AssetStrings.cameraIcon, // controller.latrineImageList[index].photoUrl != null ?
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  flex: 5,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        // online image
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: MyColors.customGrey),
                            borderRadius: BorderRadius.circular(7),
                            image: imagePath.isNotEmpty ? DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover) : null),
                      ),
                      InkWell(
                          onTap: () async {
                            //  log('img index ${imageIndexList.length}');
                            var isServiceEnabled = await op.checkLocationServiceStatus();

                            if (isServiceEnabled) {
                              if (controller.isLocationPermissionEnabled == true) {
                                if (index == 1 && agreementPath.isEmpty) {
                                  CustomSnackBar(message: "অনুগ্রহ করে আগের ধাপটি সম্পন্ন করুন", isSuccess: false).show();
                                } else if (index == 2 && (agreementPath.isEmpty || twoPitsPath.isEmpty)) {
                                  CustomSnackBar(message: "অনুগ্রহ করে আগের ধাপটি সম্পন্ন করুন", isSuccess: false).show();
                                } else if (index == 3 && (agreementPath.isEmpty || twoPitsPath.isEmpty || interiorPath.isEmpty)) {
                                  CustomSnackBar(message: "অনুগ্রহ করে আগের ধাপটি সম্পন্ন করুন", isSuccess: false).show();
                                } else if (index == 4 &&
                                    (agreementPath.isEmpty || twoPitsPath.isEmpty || interiorPath.isEmpty || exteriorPath.isEmpty)) {
                                  CustomSnackBar(message: "অনুগ্রহ করে আগের ধাপটি সম্পন্ন করুন", isSuccess: false).show();
                                } else {
                                  await _getFromCamera(index: index, op: op, leProvider: leProvider);
                                }
                              } else {
                                Geolocator.requestPermission();
                                CustomSnackBar(message: "অনুগ্রহ করে আগে লোকেশন পারমিশন দিন", isSuccess: false).show();
                              }
                            } else {
                              Geolocator.openLocationSettings();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (imgSts == 'sent')
                                  ? Image.asset(
                                      AssetStrings.checkIcon,
                                      height: 30,
                                    )
                                  : SizedBox.shrink(),
                              Image.asset(
                                AssetStrings.cameraIcon, // controller.latrineImageList[index].photoUrl != null ?
                                height: 30,
                              ),
                            ],
                          )),
                    ],
                  ),
                )
        ],
      );
    });
  }

  Widget beneficiaryInfoCard({required BeneficiaryDetailsData? beneficiary, required OperationProvider op}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
          color: MyColors.cardBackgroundColor, borderRadius: BorderRadius.circular(5), border: Border.all(color: MyColors.customGreyLight, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          op.isConnected
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${beneficiary?.banglaname ?? ''}",
                        style: MyTextStyle.primaryBold(fontSize: 17),
                      ),
                    ),
                    // Text(
                    //   "মোবাইল : ${CommonFunctions.convertNumberToBangla(beneficiary?.phone)}",
                    //   style: MyTextStyle.primaryLight(fontSize: 12),
                    // ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.beneficiary.banglaname ?? ''}",
                        style: MyTextStyle.primaryBold(fontSize: 17),
                      ),
                    ),
                    // Text(
                    //   "মোবাইল : ${CommonFunctions.convertNumberToBangla(beneficiary?.phone)}",
                    //   style: MyTextStyle.primaryLight(fontSize: 12),
                    // ),
                  ],
                ),
          op.isConnected
              ? Row(
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${beneficiary?.name}",
                        style: MyTextStyle.primaryLight(fontSize: 17),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${widget.beneficiary.name ?? ''}",
                        style: MyTextStyle.primaryLight(fontSize: 17),
                      ),
                    ),
                  ],
                ),
          op.isConnected
              ? Row(
                  children: [
                    Text(
                      'মোবাইল:',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        CommonFunctions.convertNumberToBangla(beneficiary?.phone),
                        style: MyTextStyle.primaryLight(fontSize: 16),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      'মোবাইল:',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        CommonFunctions.convertNumberToBangla(widget.beneficiary.phone),
                        style: MyTextStyle.primaryLight(fontSize: 16),
                      ),
                    ),
                  ],
                ),
          // const SizedBox(
          //   height: 5,
          // ),
          op.isConnected
              ? Row(
                  children: [
                    Text(
                      'এন আই ডি :',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${CommonFunctions.convertNumberToBangla(beneficiary?.nid)}",
                        style: MyTextStyle.primaryLight(fontSize: 16),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      'এন আই ডি :',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${CommonFunctions.convertNumberToBangla(beneficiary?.nid)}",
                        style: MyTextStyle.primaryLight(fontSize: 16),
                      ),
                    ),
                  ],
                ),
          // Text(
          //   "এন আই ডি : ${CommonFunctions.convertNumberToBangla(beneficiary?.nid)}",
          //   style: MyTextStyle.primaryLight(fontSize: 12),
          // ),
          const SizedBox(
            height: 5,
          ),
          op.isConnected == true
              ? Text(
                  "জেলা: ${beneficiary?.district?.bnName ?? ""}, উপজেলা: ${beneficiary?.upazila?.bnName ?? ""}, ইউনিয়ন: ${widget.beneficiary.union!.bnName ?? ""},ওয়ার্ড: ${widget.beneficiary.wardNo ?? ''}, বাসা/বাড়ি: ${widget.beneficiary.address ?? "--"}",
                  style: MyTextStyle.primaryLight(fontSize: 14),
                )
              : Text(
                  "জেলা: ${widget.beneficiary.district?.bnName ?? ""}, উপজেলা: ${widget.beneficiary.upazila?.bnName ?? ""}, ইউনিয়ন: ${widget.beneficiary.union?.bnName ?? ""}, বাসা/বাড়ি: ${widget.beneficiary.address ?? "--"}",
                  style: MyTextStyle.primaryLight(fontSize: 14),
                ),
          const SizedBox(
            height: 5,
          ),
          op.isConnected == true
              ? Row(
                  children: [
                    beneficiary?.isSendBack == 1
                        ? Text(
                            'Send Back Reason :',
                            style: MyTextStyle.primaryLight(fontSize: 14, fontColor: Colors.red),
                          )
                        : SizedBox.shrink(),
                    beneficiary?.isSendBack == 1
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${beneficiary?.sendBackReason}",
                                style: MyTextStyle.primaryLight(fontSize: 14, fontColor: Colors.red),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                )
              : Row(
                  children: [
                    widget.beneficiary.isSendBack == 1
                        ? Text(
                            'Send Back Reason :',
                            style: MyTextStyle.primaryLight(fontSize: 14, fontColor: Colors.red),
                          )
                        : SizedBox.shrink(),
                    widget.beneficiary.isSendBack == 1
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${widget.beneficiary.sendBackReason}",
                                style: MyTextStyle.primaryLight(fontSize: 14, fontColor: Colors.red),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
        ],
      ),
    );
  }
}
