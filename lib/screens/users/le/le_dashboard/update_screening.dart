import 'package:dphe/api/le_dashboard_api/le_dashboard_api.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/le/le_dashboard/le_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Data/models/common_models/dlc_model/beneficiary_model.dart';
import '../../../../components/custom_snackbar/custom_snakcbar.dart';
import '../../../../utils/custom_text_style.dart';

class UpdateScreeningQuestionScreen extends StatefulWidget {
  final BeneficiaryDetailsData beneficiary;
  const UpdateScreeningQuestionScreen({super.key, required this.beneficiary});

  @override
  State<UpdateScreeningQuestionScreen> createState() => _UpdateScreeningQuestionScreenState();
}

class _UpdateScreeningQuestionScreenState extends State<UpdateScreeningQuestionScreen> {
  bool isLoading = false;
  getLeQ() async {
    await Provider.of<OperationProvider>(context, listen: false).getUpdatedLeQuesAnsData(
      benfID: widget.beneficiary.id!,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeQ();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('স্ক্রীনিং সম্পাদনা'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: op.chkUpdateLeScreeningData.length,
                itemBuilder: (context, index) {
                  var leQ = op.chkUpdateLeScreeningData[index];
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
                                '${index + 1}. ${leQ.legiven.question!.title}',
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
                                  groupValue: leQ.value,
                                  onChanged: (value) {
                                    // opm.setOnVerifErrorText(isErrorText: false);
                                    op.editupdatedLeScreeningQuestion(value: value!, index: index);
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
                                  groupValue: leQ.value,
                                  onChanged: (value) {
                                    // opm.setOnVerifErrorText(isErrorText: false);
                                    op.editupdatedLeScreeningQuestion(value: value!, index: index);
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
            ),
            CustomButtonRounded(title: 'সম্পাদন করুন', onPress: () async {
              final navigator = Navigator.of(context);
              setState(() {
                isLoading = true;
              });
              op.getAllEditedUpdLeScreeningAnswer();
              final res = await LeDashboardApi().submitUpdatedScreening(beneficiaryId: widget.beneficiary.id!,leQuestionData: op.getEditedScreeningAnswer);
               setState(() {
                isLoading = false;
              });
              if (res ==  '200') {
               navigator.pop();
                  CustomSnackBar(message: "আপনার ফরমটি সফল ভাবে সাবমিট হয়েছে", isSuccess: true).show();
              } else {
                  CustomSnackBar(message: "কোথাও কোনো সমস্যা হয়েছে", isSuccess: false).show();
              }

            })
          ],
        ),
      );
    });
  }
}
