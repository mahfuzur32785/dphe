import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/provider/hive_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/twin_pit_latrine_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DlcTwinPitLatrinePage extends StatefulWidget {
  const DlcTwinPitLatrinePage({super.key});

  @override
  State<DlcTwinPitLatrinePage> createState() => _DlcTwinPitLatrinePageState();
}

class _DlcTwinPitLatrinePageState extends State<DlcTwinPitLatrinePage> {
  List<dynamic> accessList = [];

  getPermission() {}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<OperationProvider>(context, listen: false).getUpazila(districtID: 1);
    // Provider.of<OperationProvider>(context, listen: false)
    //     .getPermissionWiseOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return Scaffold(
        appBar: CustomAppbar(
          title: 'Twin Pit Latrine',
          isTwinPitLatrinePage: true,
        ),
        body: Column(
          children: [
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: op.allPermList.isNotEmpty
            //         ? op.allPermList.length
            //         : op.permList.length,
            //     itemBuilder: (context, index) {
            //       var item = op.allPermList.isNotEmpty
            //         ? op.allPermList[index]
            //         : op.permList[index];
            //       return InkWell(
            //         onTap: (){
            //           Navigator.push(context, MaterialPageRoute(builder: (context) => TwinPitLatrineDetails(title: item,),));
            //         },
            //         child: Container(
            //           margin: const EdgeInsets.all(8),
            //           padding: const EdgeInsets.all(15),
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(8),
            //             border: Border.all(color: Colors.blue)
            //           ),
            //           child: Text(op.getTwinPitLatrineDetTitle(item)),
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      );
    });
  }
}
