import 'package:dphe/api/beneficiary_api/dlc_api/dlc_report_api.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Data/models/common_models/dlc_model/work_type_model.dart';
import '../../../../components/custom_appbar/custom_appbar.dart';
import '../../../../provider/dlc_reprt_provider.dart';
import '../../../../utils/app_colors.dart';
import 'dlc_report.dart';

class DlcReportList extends StatefulWidget {
  final String upazilaName;
  final int upaID;
  final int distID;
  const DlcReportList({
    super.key,
    required this.upazilaName,
    required this.upaID,
    required this.distID,
  });

  @override
  State<DlcReportList> createState() => _DlcReportListState();
}

class _DlcReportListState extends State<DlcReportList> {
  List<WorkTypeModel>? workTypeList = [];
  @override
  void initState() {
 getWorkTypeList();
    super.initState();
  }
  getWorkTypeList()async{
   final woList = await DlcReportApi().getWorkType();
   if (woList != null) {
     setState(() {
  workTypeList = woList;
});
   }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DlcActivityReportProvider>(
      builder: (context,dac,child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: MyColors.backgroundColor,
            title: Text(
              'Reporting : ',//$upazilaName Upazila
              style: TextStyle(fontFamily: 'Roboto-Regular', fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          body: Container(
               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            child: Column(
              children: [
                ( workTypeList != null ) ?   Expanded(
                      child: ListView.builder(
                    itemCount: workTypeList!.length,
                    itemBuilder: (context, index) {
                      var item =workTypeList![index];
                      return Material(
                        child: InkWell(
                          splashColor: const Color.fromARGB(255, 233, 230, 230),
                          
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DlcReportSubmissionPage(
                              distID: widget.distID,
                              upaID: widget.upaID,
                              upazilaName: widget.upazilaName,
                              selectedActivity: item.title!,
                              assignmentID: item.id!,
                            ),));
                      
                          },
                          child: Container(
                            //height: 80,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical : 20,horizontal:8),
                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor), borderRadius: BorderRadius.circular(5)),
                            child: Center(child: Text(item.title!,textAlign: TextAlign.center,style: TextStyle(color: MyColors.primaryColor,fontWeight: FontWeight.w500,fontSize: 17),)),
                          ),
                        ),
                      );
                    },
                  )) : SizedBox.shrink()
              ],
            ),
          ),
        );
      }
    );
  }
}
