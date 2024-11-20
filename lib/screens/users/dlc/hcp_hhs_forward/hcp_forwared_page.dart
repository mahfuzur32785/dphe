import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/dlc_hhs_verification/twin_pit_le.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Data/models/common_models/dlc_model/le_data_model.dart';

class HcpForwardedListPage extends StatefulWidget {
  final int upaID;
  final int distID;
  final StswiseLeData? stsLeData;
  const HcpForwardedListPage(
      {super.key, required this.upaID, required this.distID, this.stsLeData});

  @override
  State<HcpForwardedListPage> createState() => _HcpForwardedListPageState();
}

class _HcpForwardedListPageState extends State<HcpForwardedListPage> {
  getdata() async {
    Provider.of<OperationProvider>(context, listen: false).getBeneficiaryList(
      distID: widget.distID,
      statusID: 8,
      upazilaID: widget.upaID,
      leid: widget.stsLeData!.le!.id,
      isChooseHcpForward: true,
      isLeWiseBeneficiariesPage: true,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       getdata();
     });
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //    getdata();
    //  });
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return Column(
        children: [
          // Text('Forwarded'),
     op.dlcForwardList.isEmpty ? Expanded(child: Center(child: Text('No Forwarded Data available'),)) :   op.isBenficiaryLoading ? Expanded(child: Center(child: CircularProgressIndicator(),)) :  Expanded(
            child: ListView.builder(
              itemCount: op.dlcForwardList.length,
              itemBuilder: (context, index) {
                var item = op.dlcForwardList[index];

                return InkWell(
                  onTap: () {
                    //  setState(() {
                    //           widgetSelectIndex =item!.id!;
                    //         });
                    //  op.addBenficiariesID(beID: item!.id!);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                    decoration: BoxDecoration(
                      color: MyColors.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(color: MyColors.customGreyLight, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              item?.name ?? "Unknown name",
                              style: MyTextStyle.primaryBold(fontSize: 16),
                            )),
                            Text(
                              "Mobile : ${item?.phone ?? 000000}",
                              style: MyTextStyle.primaryLight(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "NID : ${item?.nid ?? 000000}",
                          style: MyTextStyle.primaryLight(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Wrap(
                          // alignment: WrapAlignment.start,
                          direction: Axis.horizontal,

                          children: [
                            AddressCardTextWidget(
                              title: 'Address :',
                            ),
                            AddressCardTextWidget(
                              title: 'District :',
                            ),
                            AddressCardTextWidget(
                              title: '${item?.district?.name},',
                            ),
                            AddressCardTextWidget(
                              title: 'Upazila :',
                            ),
                            AddressCardTextWidget(
                              title: '${item?.upazila?.name},',
                            ),
                            AddressCardTextWidget(title: 'Union :'),
                            AddressCardTextWidget(
                                title: '${item?.union?.name ?? '' },'),
                            AddressCardTextWidget(title: ' House :'),
                            AddressCardTextWidget(
                                title: '${item?.houseName ?? ''}'),
                            
                          ],
                        ),
                            Align(alignment: Alignment.bottomRight,child: Text('Forwarded',style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold
                            ),)),
                        //Divider(),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    });
  }
}
