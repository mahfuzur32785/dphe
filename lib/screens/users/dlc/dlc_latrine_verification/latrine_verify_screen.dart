import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/screens/users/dlc/dlc_latrine_verification/pending_for_verify_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/common_widgets/common_widgets.dart';
import '../../../../components/text_input_filed/custom_search_field.dart';
import '../../../../provider/operation_provider.dart';
import '../../../../utils/custom_text_style.dart';

class PendingForVerifyLeList extends StatefulWidget {
  final String upazilaName;
  final int upaID;
  final int distID;
  const PendingForVerifyLeList(
      {super.key,
      required this.upazilaName,
      required this.upaID,
      required this.distID});

  @override
  State<PendingForVerifyLeList> createState() => _PendingForVerifyLeListState();
}

class _PendingForVerifyLeListState extends State<PendingForVerifyLeList> {
  final ltrvrfLeController = TextEditingController();
  getData() async{
   await Provider.of<OperationProvider>(context, listen: false)
        .getLeForLatrineVerification(
            distID: widget.distID, upazilaID: widget.upaID, statusID: 11);
  }

  @override
  void initState() {
   
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return SafeArea(
        child: Scaffold(
          // appBar: CustomAppbar(
          //   title: 'Latrine Installations',
          // ),
          body: RefreshIndicator(
            onRefresh: () async{
              await getData();
            },
            child: Stack(
              children: [
                ListView(),
                Column(
                  children: [
                    Container(
                      // height: size.height / 6,
                      decoration:
                          BoxDecoration(color: Color.fromARGB(255, 230, 239, 247)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              BackButton(
                                onPressed: () => Navigator.pop(context),
                              ),
                              Expanded(
                                child: Text(
                                  'Twin Pit Latrine: ${widget.upazilaName} Upazila',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          CustomSearchFieldWidget(
                            searchController: ltrvrfLeController,
                            hintText: "LE Name / Mobile No",
                            onchanged: (val) {
                              op.getLeForLatrineVerification(
                                distID: widget.distID,
                                upazilaID: widget.upaID,
                                statusID: 11,
                                isSearch: true,
                                phoneOrLe: val,
                              );
                            },
                          ),
                          //CustomTextInputFieldSuffix(controller: searchController, textInputType: TextInputType.text, hintText: 'LE Name/Mobile No')
                        ],
                      ),
                    ),
                    op.leListForLatrineVerification.isEmpty
                        ? Expanded(
                            child: Center(
                            child: Text('No Data Found'),
                          ))
                        : op.ltrVerfLoading ? Expanded(child: Center(child: CircularProgressIndicator(color: Colors.blue,),)) : Expanded(
                            child: ListView.builder(
                            itemCount: op.leListForLatrineVerification.length,
                            itemBuilder: (context, index) {
                              var item = op.leListForLatrineVerification[index];
                              return InkWell(
                                onTap: () {
                                  op.setLatrinVerfTab(val: 0);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LatrineInstallationPage(
                                          distID: widget.distID,
                                          upaID: widget.upaID,
                                          stsLeData: item,

                                        ),
                                      ));
                                },
                                child: customCard(
                                  horizontalMargin: 8,
                                  verticalMargin: 5,
                                  borderColor: Colors.black,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5, bottom: 8),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/splash/user_image_dummy.png'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    //'Le Name',
                                                    item!.le!.name!,
                                                    style: MyTextStyle.primaryBold(
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    item.le?.phone ?? '01XXXXXX',
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                item.statuses!.isNotEmpty
                                                    ? item.statuses!.first
                                                        .householdCount
                                                        .toString()
                                                    : '0',
                                                style: MyTextStyle.primaryBold(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Pending For Verification',
                                                   style: MyTextStyle.robotoHeadline(fontWeight:FontWeight.w500,fontSize: 13),
                                                // style: MyTextStyle.primaryLight(
                                                //     fontSize: 12,
                                                //     fontWeight: FontWeight.w400),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ))
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
