import 'dart:developer';

import 'package:dphe/components/common_widgets/common_widgets.dart';
import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/screens/users/dlc/hcp_hhs_forward/hcp_le_wise_bfc_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/text_input_filed/custom_search_field.dart';
import '../../../../provider/operation_provider.dart';
import '../../../../utils/custom_text_style.dart';
import '../dlc_dashboard/dlc_dashboard_page.dart';

class HcpHHsForwardPage extends StatefulWidget {
  final String upazilaName;
  final int upaID;
  final int distID;
  const HcpHHsForwardPage(
      {super.key,
      required this.upazilaName,
      required this.upaID,
      required this.distID});

  @override
  State<HcpHHsForwardPage> createState() => _HcpHHsForwardPageState();
}

class _HcpHHsForwardPageState extends State<HcpHHsForwardPage> {
  final hcpsearchController = TextEditingController();
  getData() {
    final op = Provider.of<OperationProvider>(context, listen: false);
    op.getStatusWiseLe(
      distID: widget.distID,
      upazilaID: widget.upaID,
      isSearch: false,
      statusID: 7,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       getData();
    },);
   
    return SafeArea(
      child: Consumer<OperationProvider>(builder: (context, op, child) {
        return Scaffold(
          body: Column(
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
                         IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DlcDashBoardPage(),));

                            }, icon: Icon(Icons.home))
                      ],
                    ),
                    CustomSearchFieldWidget(
                      searchController: hcpsearchController,
                      hintText: "LE Name / Mobile No",
                      onchanged: (val) {
                        op.getStatusWiseLe(
                          distID: widget.distID,
                          upazilaID: widget.upaID,
                          isSearch: true,
                          phoneOrLe: val,
                          statusID: 7,
                        );
                      },
                    ),
                    //CustomTextInputFieldSuffix(controller: searchController, textInputType: TextInputType.text, hintText: 'LE Name/Mobile No')
                  ],
                ),
              ),
             op.leListForForward.isEmpty ? Expanded(child: Center(child: Text('No Data Available'))) : Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: ListView.builder(
                  itemCount: op.leListForForward.length,
                  itemBuilder: (context, index) {
                    var item = op.leListForForward[index];
                    return InkWell(
                      onTap: () {
                           op.setDividerTab(0);
                      //  log('user id ${item.le!.id}');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HcpLeWiseBeneficiaryList(
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
                              padding: const EdgeInsets.only(top: 5, bottom: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/splash/user_image_dummy.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item!.le!.name!,
                                          style: MyTextStyle.primaryBold(
                                              fontSize: 14),
                                        ),
                                        Text(item.le?.phone ?? '01XXXXXX'),
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
                                          ? item.statuses!.first.householdCount
                                              .toString()
                                          : '0',
                                      style: MyTextStyle.primaryBold(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Pending For Forward',
                                      style: TextStyle(fontFamily: 'Roboto-Regular'),
                                      // style: MyTextStyle.primaryLight(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w500),
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
                ),
              ))
            ],
          ),
        );
      }),
    );
  }
}
