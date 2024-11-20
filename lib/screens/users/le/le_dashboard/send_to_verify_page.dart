import 'dart:developer';
import 'dart:io';

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/api/le_dashboard_api/le_dashboard_api.dart';
import 'package:dphe/components/camera_widget/camera_capture.dart';
import 'package:dphe/components/custom_appbar/custom_appbar_inner.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/offline_database/db_tables/le_tables/latrine_progress_table.dart';
import 'package:dphe/provider/network_connectivity_provider/network_connectivity_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:dphe/utils/asset_strings.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../Data/models/common_models/camera_model.dart';
import '../../../../Data/models/le_models/benificiary_models/non_selected_benificiary_list_model.dart';
import '../../../../components/camera_widget/camera_widget.dart';
import '../../../../offline_database/db_tables/le_tables/beneficiary_list_table.dart';
import '../../../../provider/le_providers/le_dashboard_provider.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/common_functions.dart';

class SendToVerifyPage extends StatefulWidget {
  final BeneficiaryDetailsData beneficiary;
  const SendToVerifyPage({super.key, required this.beneficiary});

  @override
  State<SendToVerifyPage> createState() => _SendToVerifyPageState();
}

class _SendToVerifyPageState extends State<SendToVerifyPage> {
  bool isConnectedToNet = false;
  String? latitude;
  String? longitude;
  bool locationPermission = false;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  List<File> imageList = [];
  List<int?> imageIndexList = [];
  bool pickedImage = false;
  late File imageFile;

  File? agreementFile;
  File? twoPitsFile;
  File? interiorFile;
  File? exteriorFile;
  File? completeFile;
  int? junctionSelectedOption;

  String agreementPath = "";
  String twoPitsPath = "";
  String interiorPath = "";
  String exteriorPath = "";
  String completePath = "";

  Uint8List? agreementFileUint8List;
  Uint8List? twoPitsFileUint8List;
  Uint8List? interiorFileUint8List;
  Uint8List? exteriorFileUint8List;
  Uint8List? completeFileUint8List;

  final ImagePicker picker = ImagePicker();
  bool isSubmitLoading = false;
  locationServiceStatusStream() {
    final locationProvider = Provider.of<OperationProvider>(context, listen: false);
    locationProvider.locationServiceStatusStream();
  }

  // Get from Camera
  _getFromCamera({required int index, required OperationProvider op, required LeDashboardProvider leProvider}) async {
    XFile? pickedFile;

    if (index == 2) {
      var camModel = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(),
          ));
      if (camModel != null && camModel is CameraDataModel) {
        setState(() {
          latitude = null;
          longitude = null;
          pickedFile = camModel.xpictureFile;
          latitude = camModel.latitude.toString();
          longitude = camModel.longitude.toString();
        });
        log('updated lat lng $latitude-$longitude');
      } else {
        // if (latitude == null || longitude == null) {
        CustomSnackBar(
                message: 'Cannot Fetch Latitude or Longitude at this moment.Please Check your Internet connection or Check Location Settings',
                isSuccess: false)
            .show();
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

    if (pickedFile != null) {
      saveImage(pickedImage: pickedFile!, index: index, op: op, leProvider: leProvider);
    }
  }

  String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return ((bytes / math.pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
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
      imageFile = File(savedImage.path);
      var imgSize = getFileSizeString(bytes: savedImage.lengthSync());
      log('img size $imgSize');
    });
    //imageList.insert(index,imageFile);
    ///
    // if(imageIndexList.length>index){
    //   imageIndexList.removeAt(index);
    // }
    // imageIndexList.insert(index, index);
    ///
    //print("imageIndexList ${imageIndexList.length}");
    if (index == 0) {
      agreementFile = File(savedImage.path);
      await LatrineProgressTable().updateImage(
        beneficiaryId: widget.beneficiary.id,
        photoStep1: agreementFile!.path.toString(),
      );
      getImagePathFromLocalDB();
      if (op.isConnected) {
        await LeDashboardApi().lePhotoSubmission(
          beneficiaryId: widget.beneficiary.id!,
          step1: agreementFile!.path.toString(),
        ); // update to server

        leProvider.getLatrineImages(beneficiaryId: widget.beneficiary.id!);
      }
    } else if (index == 1) {
      twoPitsFile = File(savedImage.path);
      await LatrineProgressTable().updateImage(beneficiaryId: widget.beneficiary.id, photoStep2: twoPitsFile!.path.toString());
      getImagePathFromLocalDB();
      await LeDashboardApi().lePhotoSubmission(beneficiaryId: widget.beneficiary.id!, step2: twoPitsFile!.path.toString()); // update to server
      leProvider.getLatrineImages(beneficiaryId: widget.beneficiary.id!);
    } else if (index == 2) {
      interiorFile = File(savedImage.path);

      getImagePathFromLocalDB();
      final res = await LeDashboardApi().lePhotoSubmission(
        beneficiaryId: widget.beneficiary.id!,
        step3: interiorFile!.path.toString(),
        longitude: '91.1591462', //longitude,
        latitude: '23.2893392', //latitude,
      );
      if (res == '200') {
        await LatrineProgressTable().updateImage(
          beneficiaryId: widget.beneficiary.id,
          photoStep3: interiorFile!.path.toString(),
          latitude: latitude,
          longitude: longitude,
        );
      } else {
        setState(() {
          latitude = widget.beneficiary.latitude.toString();
          longitude = widget.beneficiary.longitude.toString();
        });
        await LatrineProgressTable().updateImage(
          beneficiaryId: widget.beneficiary.id,
          photoStep3: '',
          latitude: '',
          longitude: '',
        );
      }
      leProvider.getLatrineImages(beneficiaryId: widget.beneficiary.id!);
      // getLocation();
    } else if (index == 3) {
      exteriorFile = File(savedImage.path);
      await LatrineProgressTable().updateImage(beneficiaryId: widget.beneficiary.id, photoStep4: exteriorFile!.path.toString());
      getImagePathFromLocalDB();
      if (op.isConnected) {
        await LeDashboardApi().lePhotoSubmission(
          beneficiaryId: widget.beneficiary.id!,
          step4: exteriorFile!.path.toString(),
        ); // update to server
        leProvider.getLatrineImages(beneficiaryId: widget.beneficiary.id!);
      }
    } else if (index == 4) {
      completeFile = File(savedImage.path);
      await LatrineProgressTable().updateImage(beneficiaryId: widget.beneficiary.id, photoStep5: completeFile!.path.toString());
      getImagePathFromLocalDB();
      await LeDashboardApi().lePhotoSubmission(beneficiaryId: widget.beneficiary.id!, step5: completeFile!.path.toString()); // update to server
      leProvider.getLatrineImages(beneficiaryId: widget.beneficiary.id!);
    }

    setState(() {});
  }

  // get location
  Future<void> getLocation() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
      await LatrineProgressTable()
          .updateImage(beneficiaryId: widget.beneficiary.id, photoStep3: interiorFile!.path.toString(), latitude: latitude, longitude: longitude);
      LeDashboardApi().lePhotoSubmission(
          beneficiaryId: widget.beneficiary.id!, step3: interiorFile!.path.toString(), longitude: longitude, latitude: latitude); // update to server
      //Provider.of<LeDashboardProvider>(context, listen: false).getLatrineImages(beneficiaryId: widget.beneficiary.id!);
    } catch (e) {
      print("error: $e");
    }
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
    var _latitude = widget.beneficiary.latitude;
    var _longitude = widget.beneficiary.longitude;
    if (widget.beneficiary.isSendBack == 1) {
      if (_latitude != null || _longitude != null) {
        latitude = _latitude.toString();
        longitude = _longitude.toString();
      }
    } else {
      return;
    }
  }

  setSendBackJunction() {
    final selectedJunction = widget.beneficiary.junction;

    if (selectedJunction != null) {
      junctionSelectedOption = selectedJunction == 'Y' ? 0 : 1;
    } else {
      junctionSelectedOption = null;
    }
  }

  @override
  void initState() {
    locationServiceStatusStream();
    fetchLatLngFromSendBack();
    setSendBackJunction();
    // TODO: implement initState
    getImageUrlInFile();
    checkConnectivity();
    requestPermission();
    handlePermissions();
    getImagePathFromInternet();

    getImagePathFromLocalDB();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LeDashboardProvider>(context, listen: false).getLatrineImages(beneficiaryId: widget.beneficiary.id!);
    });
    super.initState();
  }

  getImageUrlInFile() async {
    final lep = Provider.of<LeDashboardProvider>(context, listen: false);
    final op = Provider.of<OperationProvider>(context, listen: false);
    if (op.isConnected) {
      await lep.storeImageUrlInFile(beneficiaryId: widget.beneficiary.id!, op: op);
    }
  }

  void checkConnectivity() async {
    isConnectedToNet = await NetworkConnectivity().checkConnectivity();
    setState(() {});
  }

  void getImagePathFromInternet() async {
    // setState(() {
    imageIndexList.clear();
    //});

    final res = await LeDashboardApi().getLatrineImages(beneficiaryId: widget.beneficiary.id!);
    if (res != null) {
      for (int i = 0; i < res.data!.length; i++) {
        setState(() {
          imageIndexList.insert(i, i);
        });
        // if(res.data!.length>=5){
        //   completePath = res.data![4].photo??"";
        //   setState(() {});
        // }
      }
      // setState(() {});
    }
  }

  void getImagePathFromLocalDB() async {
    // setState(() {
    imageIndexList.clear();
    //});

    final res = await LatrineProgressTable().getSingleImage(beneficiaryId: widget.beneficiary.id!);
    if (res != null) {
      setState(() {
      agreementPath = res.photoStep1 ?? "";
    });

    if (agreementPath.isNotEmpty) {
      setState(() {
        imageIndexList.add(0);
        // imageIndexList.insert(0, 0);
      });
    }
    setState(() {
      twoPitsPath = res.photoStep2 ?? "";
    });
    if (twoPitsPath.isNotEmpty) {
      setState(() {
        imageIndexList.add(1);
        // imageIndexList.insert(1, 1);
      });
    }
    setState(() {
      interiorPath = res.photoStep3 ?? "";
    });
    if (interiorPath.isNotEmpty) {
      setState(() {
        imageIndexList.add(2);
        //imageIndexList.insert(2, 2);
      });
    }
    setState(() {
      exteriorPath = res.photoStep4 ?? "";
    });
    if (exteriorPath.isNotEmpty) {
      setState(() {
        imageIndexList.add(3);
        //imageIndexList.insert(3, 3);
      });
    }
    setState(() {
      completePath = res.photoStep5 ?? "";
    });
    if (completePath.isNotEmpty) {
      setState(() {
        imageIndexList.add(4);
        //imageIndexList.insert(4, 4);
      });
    }

    setState(() {
      latitude = res.latitude;
      longitude = res.longitude;
    });
    }
    
    log('local updated lat lng $latitude-$longitude');
  }

  @override
  Widget build(BuildContext context) {
    //setSendBackJunction();
    // getImagePathFromLocalDB();
    // print('latrine image length ${Provider.of<LeDashboardProvider>(context, listen: false).latrineImageList.length}');
    return Consumer2<LeDashboardProvider, OperationProvider>(builder: (context, leprovider, op, child) {
      return Scaffold(
        appBar: const CustomAppbarInner(
          title: "Send to Verify",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: op.locationServiceStatus == 'disabled'
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Please Enable your Location settings',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Geolocator.openLocationSettings();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          icon: Icon(Icons.location_on_outlined),
                          label: Text(
                            'Location Settings',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      //LeDashboardDetailsCard(statusCode: -1),
                      beneficiaryInfoCard(),
                      //Image.asset("/data/user/0/com.example.dphe/cache/scaled_314c4eb6-2e3e-4de3-b015-42c8aa28e59e6098497371297611486.jpg"),
                      //Image.file(File()),
                      titledCamera(
                        title: "পরিবার প্রধানের স্বাক্ষরিত চুক্তিপত্রের ছবি", //"স্বাক্ষরিত চুক্তি পত্রের ছবি",//"চুক্তির একটি ছবি তুলুন",
                        index: 0,
                        imageFl: agreementFile,
                        imagePath: agreementPath,
                        op: op,
                        leProvider: leprovider,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      titledCamera(
                        title: "দুই পিট ও জাংশন সহ একটি ছবি",
                        index: 1,
                        imageFl: twoPitsFile,
                        imagePath: twoPitsPath,
                        op: op,
                        leProvider: leprovider,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      titledCamera(
                        title: "ল্যাট্রিনের দরজায় দাঁড়িয়ে ল্যাট্রিনের ভিতরের প্যান ও পানির ট্যাংকের ছবি",
                        index: 2,
                        imageFl: interiorFile,
                        imagePath: interiorPath,
                        op: op,
                        leProvider: leprovider,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      titledCamera(
                          title: "পরিবারের একজন সদস্যের সাথে টুইনপিট ল্যাট্রিনের ছবি ",
                          index: 3,
                          imageFl: exteriorFile,
                          imagePath: exteriorPath ?? "",
                          op: op,
                          leProvider: leprovider),
                      const SizedBox(
                        height: 10,
                      ),
                      titledCamera(
                        title: "হস্তান্তর সার্টিফিকেটের ছবি",
                        index: 4,
                        imageFl: completeFile,
                        imagePath: completePath ?? "",
                        op: op,
                        leProvider: leprovider,
                      ),
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
                      const SizedBox(
                        height: 20,
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
                                checkConnectivity();
                                if (widget.beneficiary.isSendBack == 1) {
                                  if (leprovider.latrineImageList.length == 5) {
                                    if (isConnectedToNet == true) {
                                      if (agreementPath.isNotEmpty ||
                                          twoPitsPath.isNotEmpty ||
                                          interiorPath.isNotEmpty ||
                                          exteriorPath.isNotEmpty ||
                                          completePath.isNotEmpty) {
                                        if (junctionSelectedOption != null) {
                                          if (latitude == null || longitude == null) {
                                            CustomSnackBar(message: "৩ নং ছবি টি পুনরায় তুলুন", isSuccess: false).show();
                                          } else {
                                            setState(() {
                                              isSubmitLoading = true;
                                            });
                                            await submitWithImage(leprovider, op, junctionSelectedOption!);
                                            setState(() {
                                              isSubmitLoading = false;
                                            });
                                          }
                                        } else {
                                          CustomSnackBar(message: "জাংশন সম্পর্কিত প্রশ্নের উত্তর দিন", isSuccess: false).show();
                                        }
                                      }
                                      // final constructionRes = await LeDashboardApi().constructionComplete(beneficiaryId: widget.beneficiary.id!);
                                      // if (constructionRes == "200") {
                                      //   leprovider.nonSelectedBeneficiaryList.clear();
                                      //   leprovider.getNonSelectedBeneficiaryList(
                                      //     statusIdList: [10],
                                      //     // rows: 10,
                                      //     //upazilaId: -10,
                                      //     // unionId: -10,
                                      //     //pageNo: 1,
                                      //   );
                                      //   leprovider.getLeDashboard();
                                      //   await BeneficiaryListTable()
                                      //       .updateBeneficiary(id: widget.beneficiary.id!, statusId: 11); // bibechonadhin status id is 11
                                      //       setState(() {
                                      //   isSubmitLoading = false;
                                      // });
                                      //    setState(() {
                                      //   isSubmitLoading = false;
                                      // });
                                      //   CustomSnackBar(message: "সফলভাবে ভেরিফিকেশনের জন্য সাবমিট করা হয়েছে", isSuccess: true).show();
                                      //   if (context.mounted) {
                                      //     Navigator.of(context).pop();
                                      //   }
                                      // }
                                    } else {
                                      setState(() {
                                        isSubmitLoading = false;
                                      });
                                      CustomSnackBar(message: "ইন্টারনেট এর সাথে সংযুক্ত হন!", isSuccess: false).show();
                                    }
                                  } else if (agreementPath.isNotEmpty ||
                                      twoPitsPath.isNotEmpty ||
                                      interiorPath.isNotEmpty ||
                                      exteriorPath.isNotEmpty ||
                                      completePath.isNotEmpty) {
                                    if (junctionSelectedOption != null) {
                                      if (latitude == null || longitude == null) {
                                        CustomSnackBar(message: "৩ নং ছবি টি পুনরায় তুলুন", isSuccess: false).show();
                                      } else {
                                        setState(() {
                                          isSubmitLoading = true;
                                        });
                                        await submitWithImage(leprovider, op, junctionSelectedOption!);
                                        setState(() {
                                          isSubmitLoading = false;
                                        });
                                      }
                                    } else {
                                      CustomSnackBar(message: "জাংশন সম্পর্কিত প্রশ্নের উত্তর দিন", isSuccess: false).show();
                                    }
                                  }
                                } else {
                                  if (completePath.isNotEmpty || leprovider.latrineImageList.length >= 5) {
                                    if (isConnectedToNet == true) {
                                      if (junctionSelectedOption != null) {
                                        setState(() {
                                          isSubmitLoading = true;
                                        });
                                        await submitWithImage(leprovider, op, junctionSelectedOption!);
                                        setState(() {
                                          isSubmitLoading = false;
                                        });
                                      } else {
                                        CustomSnackBar(message: "জাংশন সম্পর্কিত প্রশ্নের উত্তর দিন", isSuccess: false).show();
                                      }
                                      //await submitWithImage(leprovider, op);
                                    } else {
                                      setState(() {
                                        isSubmitLoading = false;
                                      });
                                      CustomSnackBar(message: "ইন্টারনেট এর সাথে সংযুক্ত হন!", isSuccess: false).show();
                                    }
                                  } else {
                                    setState(() {
                                      isSubmitLoading = false;
                                    });
                                    CustomSnackBar(message: "আগে সবগুলা ছবি তুলুন", isSuccess: false).show();
                                  }
                                  setState(() {
                                    isSubmitLoading = false;
                                  });
                                  setState(() {
                                    junctionSelectedOption = null;
                                  });
                                }
                              }),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  Future<void> submitWithImage(LeDashboardProvider leDashboardProvider, OperationProvider op, int junction) async {
    final res = await LeDashboardApi().lePhotoSubmission(
      beneficiaryId: widget.beneficiary.id!,
      latitude: latitude, //lat
      longitude: longitude,
      step1: agreementPath,
      step2: twoPitsPath,
      step3: interiorPath,
      step4: exteriorPath,
      step5: completePath,
    );
    if (res == "200") {
      final constructionRes = await LeDashboardApi().constructionComplete(beneficiaryId: widget.beneficiary.id!, junction: junction == 0 ? "Y" : "T");
      if (constructionRes == "200") {
        leDashboardProvider.lePaginatedRefresh();
        leDashboardProvider.fetchNonSelectedPaginatedLeBenf(statusIdList: [10], op: op);
        // leDashboardProvider.fetc
        // leDashboardProvider.nonSelectedBeneficiaryList.clear();
        // leDashboardProvider.getNonSelectedBeneficiaryList(
        //   statusIdList: [10],
        //   //upazilaId: -10,
        //   // unionId: -10,
        //   // pageNo: 1,rows: 15,
        // );
        leDashboardProvider.getLeDashboard();
        await BeneficiaryListTable().updateBeneficiary(id: widget.beneficiary.id!, statusId: 11); // bibechonadhin status id is 11
        CustomSnackBar(message: "সফলভাবে ভেরিফিকেশনের জন্য সাবমিট করা হয়েছে", isSuccess: true).show(); //Successfully submitted for verification
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
      setState(() {
        isSubmitLoading = false;
      });
    } else {
      // if (leDashboardProvider.latrineImageList.length >= 5) {
      //   // if server has already the uploaded image but local storage has no record of it , then this function will execute
      //   leDashboardProvider.nonSelectedBeneficiaryList.clear();
      //  leDashboardProvider.getNonSelectedBeneficiaryList(
      //       statusIdList: [4],
      //       // upazilaId: -10,
      //       // unionId: -10,
      //       pageNo: 1);
      //  leDashboardProvider.getLeDashboard();
      //   await BeneficiaryListTable().updateBeneficiary(id: widget.beneficiary.id!, statusId: 11); // bibechonadhin status id is 11
      //   if (context.mounted) {
      //     Navigator.of(context).pop();
      //   }

      // }
    }
    setState(() {
      isSubmitLoading = false;
    });
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

  Widget beneficiaryInfoCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
          color: MyColors.cardBackgroundColor, borderRadius: BorderRadius.circular(5), border: Border.all(color: MyColors.customGreyLight, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                "${widget.beneficiary.banglaname}",
                style: MyTextStyle.primaryBold(fontSize: 17),
              )),
              Text(
                "মোবাইল : ${CommonFunctions.convertNumberToBangla(widget.beneficiary.phone)}",
                style: MyTextStyle.primaryLight(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "এন আই ডি : ${CommonFunctions.convertNumberToBangla(widget.beneficiary.nid)}",
            style: MyTextStyle.primaryLight(fontSize: 12),
          ),
          const SizedBox(
            height: 5,
          ),
          isConnectedToNet == true
              ? Text(
                  "ঠিকানা: ,জেলা: ${widget.beneficiary.district?.bnName ?? ""}, উপজেলা: ${widget.beneficiary.upazila?.bnName ?? ""}, ইউনিয়ন: ${widget.beneficiary.union!.bnName ?? ""},ওয়ার্ড: ${widget.beneficiary.wardNo ?? ''}, বাসা/বাড়ি: ${widget.beneficiary.address ?? "--"}",
                  style: MyTextStyle.primaryLight(fontSize: 12),
                )
              : Text(
                  "ঠিকানা: ,জেলা: ${widget.beneficiary.district?.bnName ?? ""}, উপজেলা: ${widget.beneficiary.upazila?.bnName ?? ""}, ইউনিয়ন: ${widget.beneficiary.union?.bnName ?? ""}, বাসা/বাড়ি: ${widget.beneficiary.address ?? "--"}",
                  style: MyTextStyle.primaryLight(fontSize: 12),
                ),
          const SizedBox(
            height: 5,
          ),
          isConnectedToNet == true
              ? Row(
                  children: [
                    widget.beneficiary.isSendBack == 1
                        ? Text(
                            'Send Back Reason :',
                            style: MyTextStyle.primaryLight(fontSize: 14, fontColor: Colors.red),
                          )
                        : SizedBox.shrink(),
                    widget.beneficiary.isSendBack == 1
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "${widget.beneficiary.sendBackReason}",
                              style: MyTextStyle.primaryLight(fontSize: 14, fontColor: Colors.red),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                )
              : Text(
                  "",
                  style: MyTextStyle.primaryLight(fontSize: 12),
                ),
        ],
      ),
    );
  }
}
