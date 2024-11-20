import 'package:dphe/Data/models/hiveDbModel/activity_form_model.dart';
import 'package:dphe/api/dlc_other_activity_api/other_activity_api.dart';
import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/components/text_input_filed/custom_textFIeld.dart';
import 'package:dphe/helper/date_converter.dart';
import 'package:dphe/provider/hive_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Data/models/common_models/union_model.dart';
import '../../../../components/custom_dropdown/union_dialog.dart';
import '../../../../components/text_input_filed/other_activity_textfield.dart';
import '../../../../provider/dlc_reprt_provider.dart';
import '../../../../utils/app_colors.dart';

class DlcOtherActivityDetails extends StatefulWidget {
  final String upazilaName;
  final int upaID;
  final int distID;
  final String selectedActivity;
  final int assignmentID;
  const DlcOtherActivityDetails({
    super.key,
    required this.upazilaName,
    required this.upaID,
    required this.distID,
    required this.selectedActivity,
    required this.assignmentID,
  });

  @override
  State<DlcOtherActivityDetails> createState() => _DlcOtherActivityDetailsState();
}

class _DlcOtherActivityDetailsState extends State<DlcOtherActivityDetails> {
  String? activityType;
  String? unionName;
  int? unionId;
  String currDate = DateConverter.dateFormatStyle2(DateTime.now());
  TextEditingController targetParticipantController = TextEditingController();
  TextEditingController participantAttendedController = TextEditingController();
  TextEditingController oriTrainController = TextEditingController();
  TextEditingController typeOfStkHlderController = TextEditingController();
  TextEditingController totBtchCompltController = TextEditingController();
  TextEditingController impdimentController = TextEditingController();
  TextEditingController reccomendController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  late PageController oActPageController;
  String? errorText;
  bool isFormExpanded = false;
  bool isFormSubmitLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    oActPageController = PageController(initialPage: 0);
    super.initState();
    fillUpDraftData();
  }

  @override
  void dispose() {
    targetParticipantController.dispose();
    participantAttendedController.dispose();
    oriTrainController.dispose();
    typeOfStkHlderController.dispose();
    totBtchCompltController.dispose();
    impdimentController.dispose();
    reccomendController.dispose();
    remarkController.dispose();

    super.dispose();
  }

  initDraft() {
    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);
    local.initActivityBox(widget.selectedActivity);
   // fillUpDraftData();
  }

  fillUpDraftData() {
    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);
    int index = -1;
    var activities = local.activitiesBox.values.toList();

    if (activities.isNotEmpty) {
      index = activities.indexWhere((element) => element.upaID == widget.upaID && element.actStatus == widget.selectedActivity);
      if (index != -1) {
        unionId = activities[index].unioniD;
        activityType = activities[index].activityType;
       // unionName = activities[index].
        targetParticipantController.text = activities[index].targetParticipant.toString();
        participantAttendedController.text = activities[index].attended.toString();
        typeOfStkHlderController.text = activities[index].stkHolder.toString();
        totBtchCompltController.text = activities[index].completedBatch.toString();
        impdimentController.text = activities[index].limitation.toString();
        reccomendController.text = activities[index].recmmended.toString();
        remarkController.text = activities[index].rmrk.toString();

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<DlcActivityReportProvider, OperationProvider, LocalStoreHiveProvider>(builder: (context, dlcActProvider, op, local, child) {
      initDraft();
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppbar(
          isDlcOtherActivityScreen: true,
          title: 'Other Activity : ${widget.upazilaName}',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // height: 90,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                    child: Text(
                  widget.selectedActivity,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyColors.primaryColor, fontWeight: FontWeight.w500, fontSize: 17),
                )),
              ),
              // Expanded(
              //   child: ListView.builder(

              //       itemCount: 3,
              //       itemBuilder: (context, index) {
              //         return TextButton(onPressed: () {}, child: Text('Form Submitted on 23-8-2023'));
              //       }),
              // ),
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: Colors.white,

              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text('Form Details '),
              //       IconButton(
              //         onPressed: () {
              //           setState(() {
              //             isFormExpanded = !isFormExpanded;
              //           });

              //         },
              //         icon: Icon(
              //          isFormExpanded ? Icons.arrow_drop_down_circle : Icons.add,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                    child: Text(
                      'Union (If Applicable)',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      // setState(() {
                      //   unionDropdownLoading = true;
                      // });
                      await op.getUnionListFromApi(upazillaID: widget.upaID, isOtherActivity: true);
                      // setState(() {
                      //   unionDropdownLoading = false;
                      // });
                      if (mounted) {
                        final union = await showDialog(
                          context: context,
                          builder: (context) {
                            return UnionDialog(
                              isDlcActivity: true,
                            );
                          },
                        );
                        if (union != null && union is UnionModel) {
                          setState(() {
                            unionName = union.name;
                            if (union.id == 0) {
                              unionId = null;
                            } else {
                              unionId = union.id;
                            }
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            unionName ?? 'Union',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                    child: Text(
                      'Activity Type',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        value: activityType,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
                        hint: Text('Select Type'),
                        items: dlcActProvider.otherActivityTypeList
                            .map((e) => DropdownMenuItem(
                                value: e.title,
                                child: Text(
                                  e.title!,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            activityType = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                    child: Text(
                      'Progress of activities',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ActivityTextFieldTitleWidget(
                          controller: targetParticipantController,
                          title: 'Target of participants for ${activityType ?? ''} (In Count) ',
                          txttype: TextInputType.number,
                        ),
                        ActivityTextFieldTitleWidget(
                          controller: participantAttendedController,
                          title: 'Participants attended (count)',
                          txttype: TextInputType.number,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  'Date Held', //'Target of participants for Orientation/Capacity Building Training/Meeting (In Count) '
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('${currDate}'),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          DateTime? dateTime = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now().subtract(Duration(days: 739)),
                                            lastDate: DateTime.now().add(
                                              Duration(days: 730),
                                            ),
                                          );
                                          if (dateTime != null) {
                                            setState(() {
                                              currDate = DateConverter.dateFormatStyle2(dateTime);
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.calendar_month)),
                                  ],
                                ),
                              ),
                              ActivityTextFieldTitleWidget(
                                controller: typeOfStkHlderController,
                                title: 'Type of StakeHolder Attended',
                              ),
                              ActivityTextFieldTitleWidget(
                                controller: totBtchCompltController,
                                title: 'Total Batch Completed (in count) of ${activityType ?? ''}',
                                txttype: TextInputType.number,
                                maxlines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ActivityTextFieldTitleWidget(
                    controller: impdimentController,
                    title: 'Impediments/ limitations if any',
                    isValidator: false,
                    maxlines: 3,
                  ),
                  ActivityTextFieldTitleWidget(
                    controller: reccomendController,
                    title: 'Recommendation',
                    isValidator: false,
                    maxlines: 3,
                  ),
                  ActivityTextFieldTitleWidget(
                    controller: remarkController,
                    title: 'Remarks',
                    isValidator: false,
                    maxlines: 3,
                  ),
                  isFormSubmitLoading
                      ? Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            // Expanded(
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: ElevatedButton(
                            //       style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor, foregroundColor: Colors.white),
                            //       child: Text('Draft'),
                            //       onPressed: () {
                            //         if (_formKey.currentState?.validate() ?? false) {
                            //           if (activityType != null) {
                            //             local.updateActivity(
                            //               statusName: widget.selectedActivity,
                            //               activityFormData: ActivityFormModel(
                            //                   actStatus: widget.selectedActivity,
                            //                   activityID: widget.assignmentID,
                            //                   activityType: activityType!,
                            //                   attended: int.parse(participantAttendedController.text),
                            //                   completedBatch: int.parse(totBtchCompltController.text),
                            //                   date: DateConverter.dateToApiResDate(currDate),
                            //                   districtID: widget.distID,
                            //                   limitation: impdimentController.text,
                            //                   recmmended: reccomendController.text,
                            //                   rmrk: remarkController.text,
                            //                   stkHolder: typeOfStkHlderController.text,
                            //                   targetParticipant: int.parse(targetParticipantController.text),
                            //                   unioniD: unionId,
                            //                   upaID: widget.upaID),
                            //             );
                            //             CustomSnackBar(isSuccess: true,message: 'Data Saved locally').show();
                            //           }
                            //         }
                            //       },
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 143, 197, 26), foregroundColor: Colors.white),
                                  child: Text('Submit'),
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      if (activityType != null) {
                                        setState(() {
                                          isFormSubmitLoading = true;
                                        });
                                        // bool response = true;
                                        final response = await OtherActivityApi().insertOtherActivity(
                                          activityID: widget.assignmentID,
                                          districtID: widget.distID,
                                          upaID: widget.upaID,
                                          unionID: unionId,
                                          activityType: activityType!,
                                          targetParticipant: int.parse(targetParticipantController.text),
                                          attended: int.parse(participantAttendedController.text),
                                          date: DateConverter.dateToApiResDate(currDate),
                                          stkHolder: typeOfStkHlderController.text,
                                          completedBatch: int.parse(totBtchCompltController.text),
                                          limitation: impdimentController.text,
                                          recommendation: reccomendController.text,
                                          remarks: remarkController.text,
                                        );
                                        setState(() {
                                          isFormSubmitLoading = false;
                                        });
                                        if (response.isSuccess) {
                                          //response.isSuccess
                                          // setState(() {

                                          unionId = null;
                                          targetParticipantController.clear();
                                          participantAttendedController.clear();
                                          typeOfStkHlderController.clear();
                                          totBtchCompltController.clear();
                                          impdimentController.clear();
                                          reccomendController.clear();
                                          remarkController.clear();
                                          activityType = null;
                                          unionName = null;
                                          local.activitiesBox.clear();
                                          // });
                                          setState(() {
                                            isFormSubmitLoading = false;
                                          });
                                          // _formKey.currentState!.reset();
                                          CustomSnackBar(isSuccess: true, message: response.message).show();
                                        } else {
                                           setState(() {
                                          isFormSubmitLoading = false;
                                        });
                                          CustomSnackBar(isSuccess: false, message: response.message).show();
                                        }
                                        // else {
                                        //   setState(() {
                                        //     isFormSubmitLoading = false;

                                        //     unionId = null;
                                        //     unionName = null;
                                        //     targetParticipantController.clear();
                                        //     participantAttendedController.clear();
                                        //     typeOfStkHlderController.clear();
                                        //     totBtchCompltController.clear();
                                        //     impdimentController.clear();
                                        //     reccomendController.clear();
                                        //     remarkController.clear();
                                        //     activityType = null;
                                        //   });

                                        //   CustomSnackBar(isSuccess: false, message: response.message).show();
                                        // }
                                      } else {
                                        CustomSnackBar(isSuccess: false, message: 'Please Select Union and Activity Type').show();
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: CustomButtonRounded(
                            //       title: 'Submit',
                            //       onPress: () async {
                            //         if (_formKey.currentState?.validate() ?? false) {
                            //           // if (targetParticipantController.text.isEmpty || participantAttendedController.text.isEmpty ||  totBtchCompltController.text.isEmpty) {
                            //           //   CustomSnackBar(message: 'Required Field must not be empty',isSuccess: false).show();
                            //           // }
                            //           // else
                            //           // {

                            //           if (activityType != null) {
                            //             setState(() {
                            //               isFormSubmitLoading = true;
                            //             });
                            //             bool response = true;
                            //             // final response = await OtherActivityApi().insertOtherActivity(
                            //             //   activityID: widget.assignmentID,
                            //             //   districtID: widget.distID,
                            //             //   upaID: widget.upaID,
                            //             //   unionID: unionId,
                            //             //   activityType: activityType!,
                            //             //   targetParticipant: int.parse(targetParticipantController.text),
                            //             //   attended: int.parse(participantAttendedController.text),
                            //             //   date: DateConverter.dateToApiResDate(currDate),
                            //             //   stkHolder: typeOfStkHlderController.text,
                            //             //   completedBatch: int.parse(totBtchCompltController.text),
                            //             //   limitation: impdimentController.text,
                            //             //   recommendation: reccomendController.text,
                            //             //   remarks: remarkController.text,
                            //             // );
                            //             if (response) {
                            //               //response.isSuccess
                            //               // setState(() {

                            //               unionId = null;
                            //               targetParticipantController.clear();
                            //               participantAttendedController.clear();
                            //               typeOfStkHlderController.clear();
                            //               totBtchCompltController.clear();
                            //               impdimentController.clear();
                            //               reccomendController.clear();
                            //               remarkController.clear();
                            //               activityType = null;
                            //               unionName = null;
                            //               // });
                            //               setState(() {
                            //                 isFormSubmitLoading = false;
                            //               });
                            //               // _formKey.currentState!.reset();
                            //               //CustomSnackBar(isSuccess: true, message: response.message).show();
                            //             }
                            //             // else {
                            //             //   setState(() {
                            //             //     isFormSubmitLoading = false;

                            //             //     unionId = null;
                            //             //     unionName = null;
                            //             //     targetParticipantController.clear();
                            //             //     participantAttendedController.clear();
                            //             //     typeOfStkHlderController.clear();
                            //             //     totBtchCompltController.clear();
                            //             //     impdimentController.clear();
                            //             //     reccomendController.clear();
                            //             //     remarkController.clear();
                            //             //     activityType = null;
                            //             //   });

                            //             //   CustomSnackBar(isSuccess: false, message: response.message).show();
                            //             // }
                            //           } else {
                            //             CustomSnackBar(isSuccess: false, message: 'Please Select Union and Activity Type').show();
                            //           }
                            //         }

                            //         // }
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ActivityTextFieldTitleWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? hintText;
  final TextInputType txttype;
  final int maxlines;
  final bool isValidator;

  const ActivityTextFieldTitleWidget(
      {super.key,
      required this.controller,
      required this.title,
      this.hintText,
      this.txttype = TextInputType.text,
      this.maxlines = 1,
      this.isValidator = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<DlcActivityReportProvider>(builder: (context, pr, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                title, //'Target of participants for Orientation/Capacity Building Training/Meeting (In Count) '
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: ActivityTextFieldWidget(
                controller: controller,
                textInputType: txttype,
                hintText: hintText ?? '',
                // isValidatorOn: isValidator,
                maxLines: maxlines,
                validatorFunction: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required Field must not be empty';
                  }
                  return null;
                },
                //  errorText: pr.errorText,
                onchanged: (v) {
                  // pr.setErrorText(value: v);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
