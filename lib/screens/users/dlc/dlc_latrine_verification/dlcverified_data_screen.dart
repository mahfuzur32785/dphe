import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_loader/custom_loader.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/components/text_input_filed/custom_textFIeld.dart';
import 'package:dphe/helper/date_converter.dart';
import 'package:dphe/provider/le_providers/le_dashboard_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/dlc_latrine_verification/latrine_instl_pending.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart' as carsl;
import '../../../../Data/models/common_models/dlc_model/beneficiary_model.dart';
import '../../../../Data/models/common_models/dlc_model/le_data_model.dart';
import '../../../../api/beneficiary_api/dlc_api/dlc_twin_pit_latrine_verification_api.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/custom_text_style.dart';
import '../dlc_hhs_verification/twin_pit_le.dart';

class LatrineVerifyQuestionDataScreen extends StatefulWidget {
  final BeneficiaryDetailsData? benfData;
  // final PageController pageController;
  final int upaID;
  final int distID;
  const LatrineVerifyQuestionDataScreen({
    super.key,
    this.benfData,
    required this.upaID,
    required this.distID,
    // required this.pageController,
  });

  @override
  State<LatrineVerifyQuestionDataScreen> createState() => _LatrineVerifyQuestionDataScreenState();
}

class _LatrineVerifyQuestionDataScreenState extends State<LatrineVerifyQuestionDataScreen> {
  final sendBackReasonController = TextEditingController();
  final carouselcontroller = carsl.CarouselSliderController();
  bool isVerifyLoader = false;
  bool isSendBackLoader = false;
  bool isSendBack = false;
  int? tabData;
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDlcQuestions();
  }

  getFromCamera({required OperationProvider op, bool isCamera = false}) async {
    setState(() {
      imageFile = null;
    });
    //XFile? pickedFile;

    final pickedFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      saveImage(pickedImage: pickedFile, op: op);
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

  getDlcQuestions() async {
    final op = Provider.of<OperationProvider>(context, listen: false);
    final le = Provider.of<LeDashboardProvider>(context, listen: false);
    await le.getLatrineImages(beneficiaryId: widget.benfData!.id!);
    await op.getDlcQuestionsData(benfID: widget.benfData!.id!);
    //vif (context.mounted) await op.getSendBackList(id: widget.benfData!.id!, context: context);
  }

  @override
  Widget build(BuildContext context) {
    print('IS send back ${widget.benfData?.isSendBack}');
    print('send back reason ${widget.benfData?.sendBackReason}');
    final size = MediaQuery.of(context).size;
    return Consumer2<OperationProvider, LeDashboardProvider>(builder: (context, op, le, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) async {
          // await op.getBeneficiaryList(
          //   distID: widget.distID,
          //   upazilaID: widget.upaID,
          //   isSearch: false,
          //   statusID: 11, //widget.statusID,
          //   isLeWiseBeneficiariesPage: true,
          //   leid: widget.benfData!.le!.id,
          //   isLatrInstlVerification: true,
          // );
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            leading: BackButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                op.selectDlcStatusID(value: 11);
                op.paginatedRefresh();
                await op.fetchPaginatedBenfData(
                  distID: widget.distID,
                  upazilaID: widget.upaID,
                  // isSearch: false,
                  statusID: 11,
                );
                // await op.getBeneficiaryList(
                //   distID: widget.distID,
                //   upazilaID: widget.upaID,
                //   isSearch: false,
                //   statusID: 11, //widget.statusID,
                //   isLeWiseBeneficiariesPage: true,
                //   leid: widget.benfData!.le!.id,
                //   isLatrInstlVerification: true,
                // );
                //await op.getLeForLatrineVerification(distID: widget.distID, upazilaID: widget.upaID, statusID: 11);
                navigator.pop();
              },
            ),
            title: Text(
              'Pending For Verify',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          // appBar: CustomAppbar(
          //   title: 'Pending For Verify',
          //   isLatrineDlcPendingForVerify: true,
          // ),
          body: SingleChildScrollView(
            child: SizedBox(
              // height: size.height,
              // width: size.width,
              child: Column(
                children: [
                  Container(
                    // height: 100,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                    decoration: BoxDecoration(
                      color: MyColors.cardBackgroundColor,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.benfData?.name ?? "Unknown name",
                                style: MyTextStyle.primaryBold(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "NID : ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              //style: MyTextStyle.primaryLight(fontSize: 10, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "${widget.benfData?.nid ?? ''}",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                              //style: MyTextStyle.primaryLight(fontSize: 10, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Mobile :",
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              " ${widget.benfData?.phone ?? ''}",
                              style: TextStyle(
                                fontSize: 17,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Father/',
                                  // maxLines: 2,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                ),
                                Text(
                                  'Husband Name :',
                                  // maxLines: 2,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                ),
                              ],
                            ),
                            Expanded(
                              //  flex: 2,
                              child: Text(
                                " ${widget.benfData?.fatherOrHusbandName ?? ''}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        Text(
                          'Address :',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, decoration: TextDecoration.underline),
                        ),
                        Wrap(
                          // alignment: WrapAlignment.start,
                          direction: Axis.horizontal,

                          children: [
                            AddressCardTextWidget(
                              title: 'District - ',
                            ),
                            AddressCardTextWidget(
                              title: '${widget.benfData?.district?.name},',
                            ),
                            AddressCardTextWidget(
                              title: 'Upazila - ',
                            ),
                            AddressCardTextWidget(
                              title: '${widget.benfData?.upazila?.name},',
                            ),
                            AddressCardTextWidget(title: 'Union - '),
                            AddressCardTextWidget(title: '${widget.benfData?.union?.name ?? ''} ,'),
                            AddressCardTextWidget(title: 'Ward - '),
                            AddressCardTextWidget(title: '${widget.benfData?.wardNo ?? ''}'),
                            //Text('dasd${widget.benfData!.id}')
                            //  AddressCardTextWidget(title: 'House :'),
                            // AddressCardTextWidget(title: '${widget.benfData?.address ?? ''}')
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      'Latitude : ${widget.benfData!.latitude}',
                                      style: TextStyle(fontSize: 13, color: Colors.purple, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Text(
                                    'Longitude : ${widget.benfData!.longitude}',
                                    style: TextStyle(fontSize: 13, color: Colors.purple, fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              SizedBox(height: 40, child: VerticalDivider()),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      'Pit Latitude : ${widget.benfData?.pitLatitude ?? ""}',
                                      style: TextStyle(fontSize: 13, color: Colors.purple, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Text(
                                    'Pit Longitude : ${widget.benfData?.pitLongitude ?? ''}',
                                    style: TextStyle(fontSize: 13, color: Colors.purple, fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                'Junction :',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                              ),
                              Text(
                                '${widget.benfData?.junction ?? ''}',
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Text('LE Name :', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '${widget.benfData?.le?.name ?? ''} ',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.benfData!.isLocationMatch == 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duplicate Latrine',
                                    style: TextStyle(color: Colors.red, fontSize: 16),
                                  ),
                                  Text(
                                    'Location Matched with :',
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                  (widget.benfData?.duplicateLeHHs != null || widget.benfData!.duplicateLeHHs!.isNotEmpty)
                                      ? ListView.separated(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var item = widget.benfData?.duplicateLeHHs![index];
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('${index + 1}.'),
                                                    Text('Name :',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                        )),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: Text('${item!.name}'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Phone :',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                        )),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: Text('${item.phone}'),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('NID :',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                        )),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: Text('${item.nid}'),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) => Divider(),
                                          itemCount: widget.benfData!.duplicateLeHHs!.length)
                                      : SizedBox.shrink()
                                ],
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // Text(
                    //   "NID :   ${widget.benfData?.nid ?? ''}",
                    //   style: MyTextStyle.primaryLight(fontSize: 10),
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Construction Images',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ),
                  carsl.CarouselSlider(
                    carouselController: carouselcontroller,
                    options: carsl.CarouselOptions(
                      aspectRatio: 4 / 3,
                      initialPage: 0,
                      viewportFraction: 1,
                    ),

                    // itemCount: le.latrineImageList.length,
                    items: le.latrineImageList
                        .map((e) => Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  width: size.width,
                                  // height: 500,
                                  // height: MediaQuery.of(context).size.height / 1.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        e.photoUrl!,
                                      ),
                                    ),
                                  ),
                                  // child:  Container(child: Text('${e.step!.title}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),)),
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      ' ${e.step!.title} ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // decoration: BoxDecoration(
                                  //   gradient: LinearGradient(
                                  //     colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                                  //     begin: Alignment.bottomCenter,
                                  //     end: Alignment.topCenter,
                                  //   ),
                                  // ),
                                  child: IconButton(
                                    onPressed: () {
                                      carouselcontroller.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: () {
                                      carouselcontroller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 30,
                                        color: Colors.white,
                                      )),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    final isSuccess = await showModalBottomSheet<bool>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Consumer<OperationProvider>(builder: (context, opsn, child) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                                            decoration: BoxDecoration(
                                              color: Colors.white, // //padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                      child: Text(
                                                        'Send Back Reason',
                                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller: sendBackReasonController,
                                                      maxLines: 2,
                                                      onChanged: (value) {
                                                        opsn.setModalBottomErrorText(isErrorText: false);
                                                      },
                                                      decoration: InputDecoration(
                                                        hintText: 'Write your reasons',
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(2),
                                                          borderSide: BorderSide(
                                                            width: 1.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(2),
                                                          borderSide: BorderSide(
                                                            width: 1.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        //enabledBorder:
                                                      ),
                                                    ),
                                                    opsn.modalBottomErrorText.isNotEmpty
                                                        ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                opsn.modalBottomErrorText,
                                                                style: TextStyle(color: Colors.red),
                                                              )
                                                            ],
                                                          )
                                                        : SizedBox.shrink(),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    op.chDlcSendBackQuestion.isEmpty
                                                        ? SizedBox.shrink()
                                                        : Text(
                                                            'Send Back Reason ',
                                                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 17),
                                                          ),
                                                    op.chDlcSendBackQuestion.isEmpty
                                                        ? SizedBox.shrink()
                                                        : Container(
                                                            height: 200,
                                                            child: ListView.builder(
                                                                itemCount: op.chDlcSendBackQuestion.length,
                                                                itemBuilder: (context, index) {
                                                                  return ListTile(
                                                                    title: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text('${index + 1}. ${op.chDlcSendBackQuestion[index].dlcsendQ.comments}'),
                                                                      ],
                                                                    ),
                                                                    subtitle: Text(
                                                                      'Date: ${DateConverter.formatDateIOS(op.chDlcSendBackQuestion[index].dlcsendQ.createdAt!)}',
                                                                      style: TextStyle(fontWeight: FontWeight.w400),
                                                                    ),
                                                                  );
                                                                }),
                                                          ),
                                                    // Padding(
                                                    //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    //   child: Text('${}'),
                                                    // ),

                                                    // Padding(
                                                    //   padding: const EdgeInsets.only(top: 18.0),
                                                    //   child: Text(
                                                    //     'Is Resolved ?',
                                                    //     style: TextStyle(fontWeight: FontWeight.bold),
                                                    //   ),
                                                    // ),
                                                    // Row(
                                                    //   children: [
                                                    //     Checkbox(value: false, onChanged: (v) {}),
                                                    //     Text('Yes'),
                                                    //     Row(
                                                    //       children: [
                                                    //         Checkbox(value: false, onChanged: (v) {}),
                                                    //         Text('No'),
                                                    //       ],
                                                    //     ),
                                                    //   ],
                                                    // ),

                                                    // SizedBox(height: 30,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Color.fromARGB(255, 235, 49, 49).withOpacity(0.8),
                                                                  foregroundColor: Colors.white),
                                                              onPressed: () {
                                                                 op.changeIsSendBackSts(value: null);
                                                                Navigator.pop(context, false);
                                                              },
                                                              child: Text('Cancel')),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                          child: op.latrSendBackVerificationLoading
                                                              ? CustomLoader()
                                                              : ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: MyColors.primaryColor, foregroundColor: Colors.white),
                                                                  onPressed: () async {
                                                                    if (sendBackReasonController.text.isNotEmpty) {
                                                                      opsn.latrineVerificationLoader(isSendBack: true, loading: true);
                                                                      final result = await op.sendBackLatrineVerification(
                                                                          benfID: widget.benfData!.id!, comment: sendBackReasonController.text);
                                                                      if (result['status'] == 200) {
                                                                        op.selectDlcStatusID(value: 10);
                                                                        op.changeIsSendBackSts(value: 1);
                                                                        op.setLatrinVerfTab(val: 3);
                                                                        op.paginatedRefresh();

                                                                        await op.fetchPaginatedBenfData(
                                                                          distID: widget.distID,
                                                                          upazilaID: widget.upaID,
                                                                          isSendBack: 1,
                                                                          // isSearch: false,
                                                                          statusID: 10,
                                                                        );
                                                                        // op.getBeneficiaryList(
                                                                        //     distID: widget.distID,
                                                                        //     upazilaID: widget.upaID,
                                                                        //     isSearch: false,
                                                                        //     statusID: 10,
                                                                        //     isLeWiseBeneficiariesPage: true,
                                                                        //     leid: widget.benfData!.le!.id,
                                                                        //     isLatrInstlVerification: true);
                                                                        opsn.latrineVerificationLoader(isSendBack: true, loading: false);
                                                                        // op.setLatrinVerfTab(val: 2);

                                                                        // if (context.mounted) Navigator.of(context).pop(true);
                                                                        for (var v = 0; v < 2; v++) {
                                                                          if (context.mounted) Navigator.pop(context, true);
                                                                        }

                                                                        CustomSnackBar(
                                                                          isSuccess: true,
                                                                          message: 'Successfully Submitted ',
                                                                        ).show();
                                                                      } else {
                                                                        opsn.latrineVerificationLoader(isSendBack: true, loading: false);
                                                                        CustomSnackBar(
                                                                                isSuccess: false, message: 'Send Back Failed, ${result['message']} ')
                                                                            .show();
                                                                      }
                                                                    } else {
                                                                      opsn.setModalBottomErrorText(isErrorText: true);
                                                                      opsn.latrineVerificationLoader(isSendBack: true, loading: false);
                                                                      CustomSnackBar(
                                                                              isSuccess: false, message: 'Please write your reasons for send back ')
                                                                          .show();
                                                                    }
                                                                  },
                                                                  child: Text('Submit'),
                                                                ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    );
                                    if (isSuccess != null) {
                                      if (isSuccess) {
                                        op.setLatrinVerfTab(val: 2);
                                        // widget.pageController.animateToPage(
                                        //   2,
                                        //   duration: Duration(milliseconds: 500),
                                        //   curve: Curves.easeInOut,
                                        // );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 235, 49, 49).withOpacity(0.8), foregroundColor: Colors.white),
                                  child: Text('Send Back')),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor, foregroundColor: Colors.white),
                                child: Text('Verify'),
                                onPressed: () async {
                                  final isverSuccess = await showModalBottomSheet<bool>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Consumer<OperationProvider>(builder: (context, opm, child) {
                                        return Column(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context).size.height,
                                              // margin: const EdgeInsets.symmetric(vertical: 10),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 18,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 40.0),
                                                      child: Text(
                                                        'Verification Question Answer',
                                                        style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Divider(),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemCount: opm.chDlcQuestion.length,
                                                      itemBuilder: (context, index) {
                                                        var dlcQ = opm.chDlcQuestion[index];
                                                        return Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    '${index + 1}. ${dlcQ.dlcQ.title}',
                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                                // opm.modalBottomOnVerificationErrorText.isEmpty ? SizedBox.shrink() : Flexible(child: Text(opm.modalBottomOnVerificationErrorText,style: TextStyle(color: Colors.red),))
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                                              child: (index + 1) == 5
                                                                  ? Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Radio(
                                                                              value: 1,
                                                                              groupValue: dlcQ.value,
                                                                              onChanged: (value) {
                                                                                opm.updateQuestionDlcList(value: value!, index: index);
                                                                                opm.getAllDlcAnswer();
                                                                              },
                                                                            ),
                                                                            Text('Onsite (During Construction)'),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Radio(
                                                                              value: 2,
                                                                              groupValue: dlcQ.value,
                                                                              onChanged: (value) {
                                                                                opm.updateQuestionDlcList(value: value!, index: index);
                                                                                opm.getAllDlcAnswer();
                                                                              },
                                                                            ),
                                                                            Text('Onsite (After Construction)'),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Radio(
                                                                              value: 0,
                                                                              groupValue: dlcQ.value,
                                                                              onChanged: (value) {
                                                                                opm.updateQuestionDlcList(value: value!, index: index);
                                                                                opm.getAllDlcAnswer();
                                                                              },
                                                                            ),
                                                                            Text('Over Phone'),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Radio(
                                                                              value: 1,
                                                                              groupValue: dlcQ.value,
                                                                              onChanged: (value) {
                                                                                opm.setOnVerifErrorText(isErrorText: false);
                                                                                opm.updateQuestionDlcList(value: value!, index: index);
                                                                               // opm.getAllDlcAnswer();
                                                                              },
                                                                            ),
                                                                            //dlcQ.dlcQ.id == 11 ? Text('Onsite (During Construction)') : Text('No'),
                                                                            Text('Yes'),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Radio(
                                                                              value: 0,
                                                                              groupValue: dlcQ.value,
                                                                              onChanged: (value) {
                                                                                opm.setOnVerifErrorText(isErrorText: false);
                                                                                opm.updateQuestionDlcList(value: value!, index: index);
                                                                                opm.getAllDlcAnswer();
                                                                              },
                                                                            ),
                                                                            Text('No'),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                    opm.getdlcAnswer.firstWhere((element) => element.questionId == 11,orElse: () => DlcQAnsModel(answer: null),).answer == '0'
                                                        ? SizedBox.shrink()
                                                        : InkWell(
                                                            onTap: () {
                                                              // if (opm.getdlcAnswer.firstWhere((element) => element.questionId == 11).answer == '0') {
                                                              // } else {
                                                              //   getImage(op: opm);
                                                              // }
                                                              //
                                                              //opm.getFromCamera();
                                                            },
                                                            child: Container(
                                                              // height: 60,
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal: 5,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Site image',
                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                  ),
                                                                  opm.sendBackSiteImage != null
                                                                      ? Container(
                                                                          child: Image.file(
                                                                          opm.sendBackSiteImage!,
                                                                          fit: BoxFit.cover,
                                                                          height: 60,
                                                                          width: 60,
                                                                        ))
                                                                      : IconButton(
                                                                          icon: Icon(
                                                                            Icons.camera_alt_outlined,
                                                                            size: 60,
                                                                          ),
                                                                          onPressed: () {
                                                                            opm.setOnVerifErrorText(isErrorText: false, isImageVal: true);
                                                                            getImage(op: opm);
                                                                            // opm.getFromCamera();
                                                                          },
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    opm.chDlcSendBackQuestion.isEmpty
                                                        ? SizedBox.shrink()
                                                        : Text(
                                                            'Send Back Reason :',
                                                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 17),
                                                          ),
                                                    // widget.benfData?.sendBackReason == null
                                                    //     ? SizedBox.shrink()
                                                    //     :
                                                    opm.chDlcSendBackQuestion.isEmpty
                                                        ? SizedBox.shrink()
                                                        : Container(
                                                            height: 150,
                                                            child: ListView.builder(
                                                              itemCount: opm.chDlcSendBackQuestion.length,
                                                              itemBuilder: (context, index) {
                                                                var chSendBackData = opm.chDlcSendBackQuestion[index];
                                                                return Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text('${index + 1}. ${chSendBackData.dlcsendQ.comments}'),
                                                                      Text(
                                                                        'Date: ${DateConverter.formatDateIOS(chSendBackData.dlcsendQ.createdAt!)}',
                                                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text('Is Resolved?'),
                                                                          Radio(
                                                                            value: 1,
                                                                            groupValue: chSendBackData.value,
                                                                            onChanged: (value) {
                                                                              opm.updateSendbackQuestionDlcList(value: value!, index: index);
                                                                              opm.setOnVerifErrorText(isErrorText: false);
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            'Yes',
                                                                            style: TextStyle(fontWeight: FontWeight.w400),
                                                                          ),
                                                                          Radio(
                                                                            value: 0,
                                                                            groupValue: chSendBackData.value,
                                                                            onChanged: (value) {
                                                                              opm.updateSendbackQuestionDlcList(value: value!, index: index);
                                                                              opm.setOnVerifErrorText(isErrorText: false);
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            'No',
                                                                            style: TextStyle(fontWeight: FontWeight.w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  opm.modalBottomOnVerificationErrorText,
                                                                  style: TextStyle(color: Colors.red),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              opm.chDlcQuestion.isEmpty
                                                                  ? SizedBox.shrink()
                                                                  : Padding(
                                                                      padding: const EdgeInsets.only(right: 8.0),
                                                                      child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              backgroundColor: MyColors.rejected.withOpacity(0.8),
                                                                              foregroundColor: Colors.white),
                                                                          onPressed: () {
                                                                             op.changeIsSendBackSts(value: null);
                                                                            Navigator.pop(context, false);
                                                                          },
                                                                          child: Text('Cancel')),
                                                                    ),
                                                              opm.latrQAVerificationLoading
                                                                  ? CustomLoader()
                                                                  : opm.chDlcQuestion.isEmpty
                                                                      ? SizedBox.shrink()
                                                                      : ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              backgroundColor: MyColors.primaryColor, foregroundColor: Colors.white),
                                                                          onPressed: () async {
                                                                            opm.latrineVerificationLoader(isSendBack: false, loading: true);
                                                                            opm.getAllDlcAnswer();
                                                                            opm.getAllDlcSendBackAnswer();
                                                                            if (opm.getdlcAnswer.any((element) => element.answer == "null")) {
                                                                              opm.latrineVerificationLoader(isSendBack: false, loading: false);
                                                                              opm.setOnVerifErrorText(isErrorText: true);
                                                                              //CustomSnackBar(message: 'You Must Answer All Question', isSuccess: false).show();
                                                                            } else if (opm.getsendBackAnswer != null &&
                                                                                opm.getsendBackAnswer!.any((element) => element.answer == "null")) {
                                                                              opm.latrineVerificationLoader(isSendBack: false, loading: false);
                                                                              opm.setOnVerifErrorText(isErrorText: true);
                                                                              print('send back hit true');
                                                                            } else {
                                                                              if (((opm.getdlcAnswer
                                                                                              .firstWhere((element) => element.questionId == 11)
                                                                                              .answer ==
                                                                                          '1') ||
                                                                                      (opm.getdlcAnswer
                                                                                              .firstWhere((element) => element.questionId == 11)
                                                                                              .answer ==
                                                                                          '2')) &&
                                                                                  opm.sendBackSiteImage == null) {
                                                                                opm.setOnVerifErrorText(isErrorText: true, isImageVal: true);
                                                                              } else {
                                                                                  op.changeIsSendBackSts(value: null);
                                                                                print('verification success');
                                                                                final isVerificationSuccess =
                                                                                    await DlcLatrineVerificationApi().newverifyLatrineInstallation(
                                                                                  beneficiaryId: widget.benfData!.id!,
                                                                                  dlcQuestion: opm.getdlcAnswer,
                                                                                  image: opm.sendBackSiteImage?.path,
                                                                                  sendBackQues: opm.getsendBackAnswer,
                                                                                );
                                                                                if (isVerificationSuccess == '200') {
                                                                                  op.setLatrinVerfTab(val: 2);
                                                                                  op.selectDlcStatusID(value: 12);
                                                                                  opm.setOnVerifErrorText(isErrorText: false, isImageVal: false);
                                                                                  opm.clearPrevvImg();

                                                                                  opm.paginatedRefresh();

                                                                                  await opm.fetchPaginatedBenfData(
                                                                                    distID: widget.distID,
                                                                                    upazilaID: widget.upaID,
                                                                                    // isSearch: false,
                                                                                    statusID: 12,
                                                                                  );
                                                                                  // opm.fetchPaginatedBenfData(distID: distID, upazilaID: upazilaID, statusID: 11);

                                                                                  // opm.getBeneficiaryList(
                                                                                  //     distID: widget.distID,
                                                                                  //     upazilaID: widget.upaID,
                                                                                  //     isSearch: false,
                                                                                  //     statusID: 12,
                                                                                  //     isLeWiseBeneficiariesPage: true,
                                                                                  //     leid: widget.benfData!.le!.id,
                                                                                  //     isLatrInstlVerification: true);

                                                                                  opm.latrineVerificationLoader(isSendBack: false, loading: false);

                                                                                  for (var v = 0; v < 2; v++) {
                                                                                    if (context.mounted) Navigator.pop(context, true);
                                                                                  }

                                                                                  CustomSnackBar(message: 'Successfully verified', isSuccess: true)
                                                                                      .show();
                                                                                  // op.setLatrinVerfTab(val: 1);

                                                                                  //previous
                                                                                  // widget.pageController.animateToPage(
                                                                                  //   1,
                                                                                  //   duration: Duration(milliseconds: 500),
                                                                                  //   curve: Curves.easeInOut,
                                                                                  // );
                                                                                  // if (context.mounted) {
                                                                                  //   Navigator.pop(
                                                                                  //     context,fa
                                                                                  //   );
                                                                                  // }
                                                                                } else {
                                                                                  opm.latrineVerificationLoader(isSendBack: false, loading: false);
                                                                                  CustomSnackBar(
                                                                                          message: 'Failed to connect due to internet connection',
                                                                                          isSuccess: false)
                                                                                      .show();
                                                                                }
                                                                              }

                                                                              opm.latrineVerificationLoader(isSendBack: false, loading: false);
                                                                            }
                                                                          },
                                                                          child: Text('Verify'))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                    },
                                  );
                                  if (isverSuccess != null) {
                                    if (isverSuccess) {
                                      op.setLatrinVerfTab(val: 1);
                                      //previous
                                      // widget.pageController.animateToPage(
                                      //   1,
                                      //   duration: Duration(milliseconds: 500),
                                      //   curve: Curves.easeInOut,
                                      // );
                                    }
                                  }
                                  // setState(() {
                                  //   isVerifyLoader = true;
                                  // });
                                  // op.getAllDlcAnswer();
                                  // if (op.getdlcAnswer.any((element) => element.answer == "null")) {
                                  //   setState(() {
                                  //     isVerifyLoader = false;
                                  //   });
                                  //   CustomSnackBar(message: 'You Must Answer All Question', isSuccess: false).show();
                                  // } else {
                                  //   final isVerificationSuccess =
                                  //       await op.latrineVerificationApi(benfID: widget.benfData!.id!, getdlcAnswer: op.getdlcAnswer);
                                  //   if (isVerificationSuccess) {
                                  //     setState(() {
                                  //       isVerifyLoader = false;
                                  //     });
                                  //     op.getBeneficiaryList(
                                  //         distID: widget.distID,
                                  //         upazilaID: widget.upaID,
                                  //         isSearch: false,
                                  //         statusID: 12,
                                  //         isLeWiseBeneficiariesPage: true,
                                  //         leid: widget.benfData!.le!.id,
                                  //         isLatrInstlVerification: true);

                                  //     CustomSnackBar(message: 'Successfully verified', isSuccess: true).show();
                                  //     op.setLatrinVerfTab(val: 1);
                                  //     widget.pageController.animateToPage(
                                  //       1,
                                  //       duration: Duration(milliseconds: 500),
                                  //       curve: Curves.easeInOut,
                                  //     );
                                  //     if (context.mounted) {
                                  //       Navigator.pop(
                                  //         context,
                                  //       );
                                  //     }
                                  //   } else {
                                  //     setState(() {
                                  //       isVerifyLoader = false;
                                  //     });
                                  //     CustomSnackBar(message: 'Failed to connect due to internet connection', isSuccess: false).show();
                                  //   }
                                  // }
                                  // await op.latrineVerificationApi(
                                  //     benfID: widget.benfData!.id!,getdlcAnswer: op.getdlcAnswer);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  getImage({required OperationProvider op}) async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Camera"),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("gallery "),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          // Row(
          //   children: [
          //     ElevatedButton(onPressed: (){
          //       Navigator.pop(context);

          //     }, child: Text('Back'))
          //   ],
          // )
        ],
      ),
    );

    if (isCamera == null) return;
    if (mounted) {
      op.getFromCamera(isCamera: isCamera, ctx: context);
    }
  }
}
