import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityProvider extends ChangeNotifier {
  // ConnectivityStatus _status = ConnectivityStatus.Offline;
  //
  // ConnectivityStatus get status => _status;

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi) {
      //_status = ConnectivityStatus.WiFi;
      //CustomSnackBar(message:"Connected to wifi").show();
      return true;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      //CustomSnackBar(message:"Connected to mobile").show();
     // _status = ConnectivityStatus.Cellular;
      return true;
    } else if (connectivityResult == ConnectivityResult.none){
      CustomSnackBar(message:"You are currently offline", isSuccess: false).show();
      //_status = ConnectivityStatus.Offline;
      return false;
    }
    return false;
    // print(_status);
    // CustomSnackBar(message: _status.toString()).show();

    notifyListeners();
  }
}



class NetworkConnectivity{
  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none){
      //CustomSnackBar(message:"You are currently offline", isSuccess: false).show();
      return false;
    }
    return false;
  }
}
