import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../Data/models/common_models/camera_model.dart';
import '../../helper/date_converter.dart';
import '../../provider/operation_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  bool isMockEnabled = false;
  StreamSubscription<Position>? _positionStreamSubscription;
  late final Future<void> _future;
  CameraController? _cameraController;
  bool isCamButtonLoading = false;
  double? latitude;
  double? longitude;
  // final textRecognizer = TextRecognizer();

  locationUpdate() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );
    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      if (position != null) {
        if (position.isMocked) {
          setState(() {
            isMockEnabled = true;
          });
          CustomSnackBar(message: 'Do not use Fake location', isSuccess: false).show();
        } else {
          setState(() {
            latitude = null;
            longitude = null;
            isMockEnabled = false;
            latitude = position.latitude;
            longitude = position.longitude;
          });
          print('position stream ${latitude.toString()}= longitude ${longitude.toString()}');
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    locationUpdate();
    WidgetsBinding.instance.addObserver(this);
    // _future = _requestCameraPermission();
  }

  // Future<void> _requestCameraPermission() async {
  //   Provider.of<OperationProvider>(context, listen: false).requestCameraPermission();
  //   // final status = await Permission.camera.request();
  //   // _isPermissionGranted = status == PermissionStatus.granted;
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    //textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed && _cameraController != null && _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return FutureBuilder(
        future: op.requestCameraPermission(),
        //future: _future,
        builder: (context, snapshot) {
          return SafeArea(
            child: Stack(
              // alignment: Alignment.center,
              children: [
                if (op.isCameraPermissionGranted)
                  FutureBuilder<List<CameraDescription>>(
                      future: availableCameras(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _initCameraController(snapshot.data!);
                          return Stack(
                            //fit: StackFit.expand,
                            children: [
                              CameraPreview(_cameraController!),
                              // RotatedBox(
                              //     quarterTurns: 1 - _cameraController!.description.sensorOrientation ~/ 90, child: CameraPreview(_cameraController!)),
                              Material(
                                child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(color: Colors.white),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     // BackButton(
                                        //     //   onPressed: () {
                                        //     //    Navigator.of(context).pop();
                                        //     //   },
                                        //     // ),

                                        //     Text(
                                        //       'Date :',
                                        //       style: TextStyle(fontSize: 17, color: Colors.black),
                                        //     ),
                                        //     Text(
                                        //       '${DateConverter.formatDate(DateTime.now())}',
                                        //       style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 108, 104, 104)),
                                        //     ),
                                        //   ],
                                        // ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Latitude : ${latitude == null ? '' : latitude.toString()}, longitude : ${longitude == null ? '' : longitude.toString()}',
                                                style: TextStyle(fontSize: 17, color: Colors.black),
                                              ),
                                            ),
                                            // Text(
                                            //   '${latitude.toString()}',
                                            //   style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 108, 104, 104)),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          );
                        } else {
                          return const LinearProgressIndicator();
                        }
                      }),
                Scaffold(
                  backgroundColor: op.isCameraPermissionGranted ? Colors.transparent : null,
                  body: op.isCameraPermissionGranted
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Container()),
                            // Container(
                            //   color: Colors.white,
                            //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text('Lat: ',),
                            //       Text('Lng:'),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              //height: 20,
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  IconButton(
                                    onPressed: op.isCameraLoading
                                        ? null
                                        : () {
                                            backFromCamera();
                                          },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  op.isCameraLoading
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(right: 30.0),
                                          child: Center(
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  )),
                                              onPressed: isMockEnabled
                                                  ? null
                                                  : () {
                                                      captureImage(op: op);
                                                    },
                                              label: const Text('Capture'),
                                              icon: Icon(Icons.camera),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Container(
                            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: const Text('Camera permission denied'),
                          ),
                        ),
                )
              ],
            ),
          );
        },
      );
    });
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.max);
    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  backFromCamera() {
    CameraDataModel cameraDataModel = CameraDataModel(
      xpictureFile: null,
    );
    Navigator.of(context).pop(cameraDataModel);
  }

  captureImage({required OperationProvider op}) async {
    if (_cameraController == null) return;
    final navigator = Navigator.of(context);
    op.isCamLoading(value: true);
    try {
      CameraDataModel cameraDataModel = CameraDataModel();
      //double? latitude;
      //double? longitude;
      if (latitude == null && longitude == null) {
        var position = await op.getUsersPosition();
        if (position != null) {
          if (position.isMocked) {
            CustomSnackBar(message: 'Do not use Fake location', isSuccess: false).show();
          } else {
            latitude = position.latitude;
            longitude = position.longitude;
            final pictureFile = await _cameraController!.takePicture();
            cameraDataModel = CameraDataModel(xpictureFile: pictureFile, latitude: latitude, longitude: longitude);
            op.isCamLoading(value: false);
            navigator.pop(cameraDataModel);
          }
        } else {
          op.isCamLoading(value: false);
          navigator.pop(null);
        }
      } else {
        final pictureFile = await _cameraController!.takePicture();
        cameraDataModel = CameraDataModel(
          xpictureFile: pictureFile,
          latitude: latitude,
          longitude: longitude,
        );
        op.isCamLoading(value: false);
        navigator.pop(cameraDataModel);
      }

      // if (position != null) {
      //   //latitude != null && longitude != null
      //   //position != null
      // } else {
      //   op.isCamLoading(value: false);
      //   navigator.pop(null);
      //   // Geolocator.openLocationSettings();
      // }

      //var s = pictureFile.path;
      //   final file = File(pictureFile.path);

      //    final appDir = await getApplicationDocumentsDirectory(); // Or any other directory you prefer
      // final uniqueFileName = DateTime.now().microsecondsSinceEpoch;
      // final savedImage = File('${appDir.path}/$uniqueFileName.jpg');
      // await savedImage.writeAsBytes(await pictureFile.readAsBytes());
      //var s= file.toString();
      //final byte = file.readAsBytesSync();

      // navigator.pop(pictureFile);
      //await navigator.push(MaterialPageRoute(builder: (BuildContext context) => ResultScreen(text: recognizedText.text)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
    op.isCamLoading(value: false);
  }
}

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Text(text),
        ),
      );
}
