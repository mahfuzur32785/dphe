import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_constant.dart';
import '../../../../utils/local_storage_manager.dart';

class TwinpitActivityDetails extends StatefulWidget {
  final String title;
  const TwinpitActivityDetails({super.key, required this.title});

  @override
  State<TwinpitActivityDetails> createState() => _TwinpitActivityDetailsState();
}

class _TwinpitActivityDetailsState extends State<TwinpitActivityDetails> {
//   String? userPhoto;
//  getImage()async{
//      userPhoto = await LocalStorageManager.readData(AppConstant.userPhoto);
//    setState(() {
     
//    });
//   }

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationProvider>(
      builder: (context,op,child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppbar(
            title: widget.title,
            isTwinActivitiesDetailsDshbrd: true,
            isTpActDashboard: false,
           // userPhoto: userPhoto,
          ),
          body: Column(
            children: [
              Expanded(
                  child: GridView.builder(

                    itemCount: op.twinPitActivitiesDshBoardList.length,
                  
                    padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 100,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,

                    ),
                    itemBuilder: (context, index) {
                      var item = op.twinPitActivitiesDshBoardList[index];
                      return InkWell(
                        onTap: () {
                         item.routeName != null ? Navigator.push(context, MaterialPageRoute(builder: (context) => item.routeName!,)) : null;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                        
                          decoration: BoxDecoration(
                            color: item.tileColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(
                            child: Text(item.title!, textAlign:  TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      }
    );
  }
}