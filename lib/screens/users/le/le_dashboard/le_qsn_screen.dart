import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dphe/components/custom_appbar/custom_appbar_inner.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/offline_database/db_tables/le_tables/le_qsn_ans_table.dart';
import 'package:dphe/provider/le_providers/le_dashboard_provider.dart';
import 'package:dphe/provider/network_connectivity_provider/network_connectivity_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/le/custom_widgets/le_qsn_card.dart';
import 'package:dphe/utils/app_strings.dart';
import 'package:dphe/utils/static_list.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../Data/models/common_models/camera_model.dart';
import '../../../../api/le_dashboard_api/le_dashboard_api.dart';
import '../../../../Data/models/le_models/le_dashboard_models/le_qsn_model.dart';
import '../../../../components/camera_widget/camera_widget.dart';
import '../../../../offline_database/db_tables/le_tables/beneficiary_list_table.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/asset_strings.dart';
import '../../../../utils/custom_text_style.dart';

class LeQsnScreen extends StatefulWidget {
  final int beneficiaryId;
  const LeQsnScreen({super.key, required this.beneficiaryId});

  @override
  State<LeQsnScreen> createState() => _LeQsnScreenState();
}

class _LeQsnScreenState extends State<LeQsnScreen> {
  List<LeAnsModel> leAnsList = [
    LeAnsModel(id: 1, ans: null),
    LeAnsModel(id: 2, ans: null),
    LeAnsModel(id: 3, ans: null),
    LeAnsModel(id: 4, ans: null),
    LeAnsModel(id: 5, ans: null),
    LeAnsModel(id: 6, ans: null),
  ];
  bool isQASubmitLoading = false;
  // List<LeAnsModel> leAnsList = [
  //   LeAnsModel(id: 1, ans: 0),
  //   LeAnsModel(id: 2, ans: 0),
  //   LeAnsModel(id: 3, ans: 0),
  //   LeAnsModel(id: 4, ans: 0),
  //   LeAnsModel(id: 5, ans: 0),
  //   LeAnsModel(id: 6, ans: 0),
  // ];
  bool isConnectedToNet = false;
  String latitude = '';
  String longitude = '';
  bool locationPermission = false;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  bool isPageLoading = false;
  // Get from Camera
  _getFromCamera({required OperationProvider op}) async {
    XFile? pickedFile;
    var camModel = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(),
        ));
    if (camModel != null && camModel is CameraDataModel) {
      if (camModel.latitude != null || camModel.longitude != null) {
        setState(() {
          pickedFile = camModel.xpictureFile;
          latitude = camModel.latitude.toString();
          longitude = camModel.longitude.toString();
        });
      }
    }

    // XFile? pickedFile = await picker.pickImage(
    //   source: ImageSource.camera,
    //   maxWidth: 1800,
    //   maxHeight: 1800,
    // );
    if (pickedFile != null) {
      saveImage(pickedImage: pickedFile!, op: op);
    }
  }

  Future<void> saveImage({required XFile pickedImage, required OperationProvider op}) async {
    final imgByte = await op.getUint8ListFile(File(pickedImage.path));
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
    setState(() {
      imageFile = File(savedImage.path);
    });
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
        Navigator.of(context).pop();
        Provider.of<LeDashboardProvider>(context, listen: false).setLocationPermission(permission: false);
        return false;
      }
    } else if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      //setState(() {
      //locationPermission = true;
      Provider.of<LeDashboardProvider>(context, listen: false).setLocationPermission(permission: true);
      //});
    }

    return true;
  }

  getLeQuestions() async {
    setState(() {
      isPageLoading = true;
    });
    await Provider.of<OperationProvider>(context, listen: false).getLEQuestionsData(benfID: widget.beneficiaryId);
    setState(() {
      isPageLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // requestPermission();
    // handlePermissions();
    getLeQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return Scaffold(
        appBar: const CustomAppbarInner(
          title: "প্রশ্ন সমূহ ",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: isPageLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: op.chLEQuestion.length,
                        itemBuilder: (context, index) {
                          var LeQ = op.chLEQuestion[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${index + 1}. ${LeQ.dlcQ.title}',
                                        style: TextStyle(fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  // opm.modalBottomOnVerificationErrorText.isEmpty ? SizedBox.shrink() : Flexible(child: Text(opm.modalBottomOnVerificationErrorText,style: TextStyle(color: Colors.red),))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: LeQ.value,
                                          onChanged: (value) {
                                            // opm.setOnVerifErrorText(isErrorText: false);
                                            op.updateLeScreeningQuestion(value: value!, index: index);
                                          },
                                        ),
                                        //dlcQ.dlcQ.id == 11 ? Text('Onsite (During Construction)') : Text('No'),
                                        Text('হ্যাঁ', style: MyTextStyle.primaryLight(fontSize: 14)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 0,
                                          groupValue: LeQ.value,
                                          onChanged: (value) {
                                            // opm.setOnVerifErrorText(isErrorText: false);
                                            op.updateLeScreeningQuestion(value: value!, index: index);
                                          },
                                        ),
                                        Text('না', style: MyTextStyle.primaryLight(fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      // ListView.builder(
                      //   itemCount: op.chLEQuestion.length,
                      //     //itemCount: StaticList().leQsnList.length,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     itemBuilder: (BuildContext context, int index) {
                      // return LeQsnCard(
                      //         index: index,
                      //         qsnObject: StaticList().leQsnList[index],
                      //         ans: (value) {
                      //           print('question value answer $value');
                      //           leAnsList.removeAt(index);
                      //           leAnsList.insert(index, LeAnsModel(id: StaticList().leQsnList[index].id, ans: value));
                      //           print('answer length ${leAnsList.length}');
                      //         },
                      //       );
                      //     }),
                      const SizedBox(
                        height: 20,
                      ),
                      cameraContainer(title: "সাইট সিলেকশন ছবি তুলুন", imageFl: imageFile, op: op),
                      const SizedBox(
                        height: 40,
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     if (latitude.isEmpty || longitude.isEmpty) {
                      //       debugPrint('no lat lng');
                      //     }else{
                      //       debugPrint('lat lng');
                      //     }

                      //   },
                      //   child: Text('test'),
                      // ),

                      Consumer<LeDashboardProvider>(builder: (context, controller, child) {
                        return isQASubmitLoading
                            ? CircularProgressIndicator()
                            : op.chLEQuestion.isEmpty
                                ? SizedBox.shrink()
                                : CustomButtonRounded(
                                    title: AppStrings.submit,
                                    onPress: () async {
                                      op.getAllLeScreeningAnswer();
                                      //controller.postLeAns(beneficiaryId: widget.beneficiaryId, ansList: leAnsList);
                                      if ((op.getLEAnswer[0].answer == "null" ||
                                          op.getLEAnswer[1].answer == "null" ||
                                          op.getLEAnswer[2].answer == "null" ||
                                          op.getLEAnswer[3].answer == "null" ||
                                          op.getLEAnswer[4].answer == "null" ||
                                          op.getLEAnswer[5].answer == "null")) {
                                        CustomSnackBar(message: "সবগুলো প্রশ্নের উত্তর দিতে হবে ", isSuccess: false).show();
                                      } else {
                                        if (latitude.isNotEmpty && longitude.isNotEmpty && imageFile != null) {
                                          setState(() {
                                            isQASubmitLoading = true;
                                          });
                                          final isConnected = await NetworkConnectivity().checkConnectivity();
                                          if (isConnected == true) {
                                            // final res = await LeDashboardApi().leAnsQsnPost(
                                            //   beneficiaryId: widget.beneficiaryId,
                                            //   ans1: leAnsList[0].ans!,
                                            //   ans2: leAnsList[1].ans!,
                                            //   ans3: leAnsList[2].ans!,
                                            //   ans4: leAnsList[3].ans!,
                                            //   ans5: leAnsList[4].ans!,
                                            //   ans6: leAnsList[5].ans!,
                                            //   lat: latitude,
                                            //   long: longitude,
                                            //   image: imageFile!.path.toString(),
                                            // );
                                            final res = await LeDashboardApi().newLeQuestionAnswerSubmit(
                                              beneficiaryId: widget.beneficiaryId,
                                              jsonAnswer: jsonEncode(op.getLEAnswer),
                                              lat: latitude,
                                              long: longitude,
                                              image: imageFile!.path.toString(),
                                            );
                                            if (res == "200") {
                                              await BeneficiaryListTable().updateBeneficiary(id: widget.beneficiaryId, isQuestionAnswer: 1);
                                              if (context.mounted) Navigator.of(context).pop();
                                              controller.lePaginatedRefresh();
                                              //controller.nonSelectedBeneficiaryList.clear();
                                              controller.fetchNonSelectedPaginatedLeBenf(statusIdList: [9], op: op);
                                              // controller.getNonSelectedBeneficiaryList(
                                              //   statusIdList: [9],
                                              //   // pageNo: 1,
                                              //   // rows: 15,
                                              // );
                                              controller.getLeDashboard();
                                              CustomSnackBar(message: "আপনার ফরমটি সফল ভাবে সাবমিট হয়েছে", isSuccess: true).show();
                                              setState(() {
                                                isQASubmitLoading = false;
                                              });
                                            } else {
                                              CustomSnackBar(message: "কোন সমস্যা দেখা দিয়েছে", isSuccess: false).show();
                                              setState(() {
                                                isQASubmitLoading = false;
                                              });
                                            }
                                          } else {
                                            final res = await LeQsnAnsTable().insertAns(
                                                beneficiaryId: widget.beneficiaryId,
                                                jsonAns: jsonEncode(op.getLEAnswer),
                                                lat: latitude,
                                                long: longitude,
                                                image: imageFile!.path.toString());
                                            if (res != 0) {
                                              await BeneficiaryListTable()
                                                  .updateBeneficiary(id: widget.beneficiaryId, isQuestionAnswer: 1, statusId: 10);
                                              CustomSnackBar(message: "আপনার ফরমটি সফল ভাবে সাবমিট হয়েছে", isSuccess: true).show();
                                              if (context.mounted) Navigator.of(context).pop();
                                              controller.lePaginatedRefresh();
                                              //controller.nonSelectedBeneficiaryList.clear();
                                              controller.fetchNonSelectedPaginatedLeBenf(statusIdList: [3], op: op);
                                              // controller.getNonSelectedBeneficiaryList(
                                              //   statusIdList: [3],
                                              //   upazilaId: null,
                                              //   unionId: null,
                                              //   // pageNo: 1,
                                              //   // rows: 15,
                                              // );
                                              controller.getLeDashboard();
                                            }
                                            setState(() {
                                              isQASubmitLoading = false;
                                            });
                                          }
                                        } else {
                                          CustomSnackBar(message: "সবগুলো প্রশ্নের উত্তর দিতে হবে এবং ছবি অবশ্যই দিতে হবে ", isSuccess: false).show();
                                        }
                                      }
                                    });
                      }),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  // camera container
  Widget cameraContainer({required String title, File? imageFl, required OperationProvider op}) {
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
                Text(
                  "Latitude : $latitude\nLongitude : $longitude",
                  style: MyTextStyle.primaryLight(fontSize: 14, fontColor: MyColors.customMagenta),
                ),
              ],
            )),
        Expanded(
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
                    image: imageFile != null
                        ? DecorationImage(
                            image: FileImage(
                              imageFile!,
                            ),
                            fit: BoxFit.cover)
                        : null),
                // child: imageFile != null
                //     ? Image.file(
                //         imageFile!,
                //         fit: BoxFit.fill,
                //       )
                //     : const SizedBox(),
              ),
              InkWell(
                  onTap: () async {
                    var isServiceEnabled = await op.checkLocationServiceStatus();
                    LocationPermission permission = await Geolocator.checkPermission();
                    if (!isServiceEnabled) {
                      Geolocator.openLocationSettings();
                    } else if (await Permission.location.isDenied) {
                      Geolocator.openAppSettings();
                    } else if (await Permission.location.isPermanentlyDenied) {
                      Geolocator.openAppSettings();
                    } else if (permission == LocationPermission.denied) {
                      CustomSnackBar(message: "অনুগ্রহ করে আগে লোকেশন পারমিশন দিন", isSuccess: false).show();
                      await Geolocator.requestPermission();
                    } else {
                      await _getFromCamera(op: op);
                    }
                  },
                  child: Image.asset(
                    AssetStrings.cameraIcon,
                    height: 30,
                  )),
            ],
          ),
        )
      ],
    );
  }
}
