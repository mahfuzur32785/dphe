import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/dlc_reprt_provider.dart';
import 'other_activity_details_form.dart';

class DlcOtherActivityListScreen extends StatelessWidget {
  final String upazilaName;
  final int upaID;
  final int distID;
  const DlcOtherActivityListScreen({super.key, required this.upazilaName, required this.upaID, required this.distID});

  @override
  Widget build(BuildContext context) {
    Provider.of<DlcActivityReportProvider>(context,listen: false).getDlcOtherActivityAssignmentList();
    return Consumer<DlcActivityReportProvider>(builder: (context, othActProvider, child) {
      return Scaffold(
        appBar: CustomAppbar(
          isDlcOtherActivityScreen: true,
          title: 'Other Activity : $upazilaName',
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                itemCount: othActProvider.dlcActivityData.length,
                itemBuilder: (context, index) {
                  var item = othActProvider.dlcActivityData[index];
                  return Material(
                    child: InkWell(
                      splashColor: const Color.fromARGB(255, 233, 230, 230),
                      
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DlcOtherActivityDetails(
                          distID: distID,
                          upaID: upaID,
                          upazilaName: upazilaName,
                          selectedActivity: item.name!,
                          assignmentID: item.id!,
                        ),));
                  
                      },
                      child: Container(
                        //height: 80,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(vertical : 20,horizontal:8),
                        decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor), borderRadius: BorderRadius.circular(5)),
                        child: Center(child: Text(item.name!,textAlign: TextAlign.center,style: TextStyle(color: MyColors.primaryColor,fontWeight: FontWeight.w500,fontSize: 17),)),
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      );
    });
  }
}
