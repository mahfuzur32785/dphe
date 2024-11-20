import 'package:dphe/offline_database/sync_online.dart';
import 'package:dphe/screens/users/le/le_dashboard/le_dashboard.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DataSyncLoader extends StatefulWidget {
  const DataSyncLoader({super.key});

  @override
  State<DataSyncLoader> createState() => _DataSyncLoaderState();
}

class _DataSyncLoaderState extends State<DataSyncLoader> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    Provider.of<SyncOnlineProvider>(context, listen: false).leDashboardDataSync();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SyncOnlineProvider>(
      builder: (context, controller, child) {
        return controller.isDataSynchronizingLe==true?
        Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //const CircularProgressIndicator(),
                Lottie.asset('assets/json_files/loader_animation.json',height: MediaQuery.of(context).size.height*.28),
                const SizedBox(height: 10,),
                Text(" Data is synchronizing, please wait!", style: MyTextStyle.primaryLight(fontSize: 16),),
              ],
            ),
          ),
        ):const LeDashboard();
      }
    );
  }
}
