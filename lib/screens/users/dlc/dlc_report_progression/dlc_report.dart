import 'package:dphe/provider/dlc_reprt_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_colors.dart';

class DlcReportSubmissionPage extends StatefulWidget {
  final String upazilaName;
  final int upaID;
  final int distID;
  final String selectedActivity;
  final int assignmentID;

  const DlcReportSubmissionPage(
      {super.key, required this.upazilaName, required this.upaID, required this.distID, required this.selectedActivity, required this.assignmentID});

  @override
  State<DlcReportSubmissionPage> createState() => _DlcReportSubmissionPageState();
}

class _DlcReportSubmissionPageState extends State<DlcReportSubmissionPage> {
  int? packageID;
  String? packageName;

  int? schemeTypeId;
  String? schemetitle;

  getPackage() async {
    await Provider.of<DlcActivityReportProvider>(context, listen: false).getPackageInfoProvider();
  }

  @override
  void initState() {
    super.initState();
    getPackage();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DlcActivityReportProvider>(builder: (context, rep, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      // height: 100,
                      decoration: BoxDecoration(
                        color: MyColors.backgroundColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Report Submission: ${widget.selectedActivity}',
                              style: TextStyle(fontFamily: 'Roboto-Regular', fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        value: packageName,
                        hint: Text('Select Package'),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        isExpanded: true,
                        items: rep.packageDataList
                            .map((e) => DropdownMenuItem(
                                value: e.title,
                                onTap: () {
                                  // setState(() {
                                  packageID = e.id;
                                  print(packageID);
                                  rep.getSchemeData(id: e.id!);
          
                                  // });
                                },
                                child: Text(e.title!)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            packageName = value;
                          });
                        },
                      )),
                      // child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [Text('Select Package'), Icon(Icons.arrow_drop_down_circle_outlined)],
                      // ),
                    ),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        value: schemetitle,
                        hint: Text('Select Scheme'),
                        isExpanded: true,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        items: rep.schemeDataList
                            .map((e) => DropdownMenuItem(
                                value: e.title,
                                onTap: () {
                                  // setState(() {
                                  schemeTypeId = e.schemeTypeId;
                                  print('schemetype $schemeTypeId');
                                  if (schemeTypeId != null) {
                                    rep.getProgressItem(schemeData: e.schemeTypeId!);
                                  }
          
                                  // });
                                },
                                child: Text(e.title!)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            schemetitle = value;
                          });
                        },
                      )),
                      // child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [Text('Select Package'), Icon(Icons.arrow_drop_down_circle_outlined)],
                      // ),
                    ),
          
                    
                    // Container(
                    //   //padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                    //   margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     // border: Border.all(color: Colors.grey,),
                    //     // borderRadius: BorderRadius.circular(20)
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Capture Site Photo',
                    //         style: TextStyle(fontWeight: FontWeight.w500),
                    //       ),
                    //       Expanded(
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(horizontal: 8),
                    //           child: Stack(
                    //             alignment: Alignment.center,
                    //             children: [
                    //               Container(
                    //                 height: 120,
                    //                 decoration: BoxDecoration(
                    //                     border: Border.all(
                    //                       color: Colors.grey,
                    //                     ),
                    //                     borderRadius: BorderRadius.circular(10)),
                    //                 // child: Center(child: Icon(Icons.camera_alt,color: Colors.blue,)),
                    //               ),
                    //               Icon(
                    //                 Icons.camera_alt,
                    //                 color: Colors.blue,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Construction Phase/Items', style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: rep.chProgressItemQuesList.length,
                      itemBuilder: (context, index) {
                    var progItem = rep.chProgressItemQuesList[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                      child: Row(
                        children: [
                          Radio(
                            
                            value: 1,
                            groupValue: progItem.value,
                            onChanged: (value) {
                              rep.updateProgItemQuestion(value: value!, index: index);
                            },
                          ),
                          Flexible(flex: 3,child: Text(progItem.progItem.title!)),
                          Flexible(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                            child: Text('${progItem.progItem.itemPercent!}%'),
                          ))
                        ],
                      ),
                    );
                      },
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:10.0),
                        child: SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white),onPressed: (){
                                            
                          }, child: Text('Submit')),
                        ),
                      ),
                    )
                    // ListView(
                    //   children: [
          
                    //   ],
                    // )
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
