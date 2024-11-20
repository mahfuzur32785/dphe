import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/le/le_dashboard/send_to_verify_page.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../Data/models/common_models/camera_model.dart';
import '../../Data/models/common_models/dlc_model/beneficiary_model.dart';
import '../../helper/date_converter.dart';

class CaptureImage extends StatefulWidget {
  const CaptureImage({
    super.key,
  });

  @override
  State<CaptureImage> createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  late final Future<void> _future;
  CameraController? _cameraController;

  XFile? captureImgFile;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    // _future = _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
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
    final size = MediaQuery.of(context).size;

    return Consumer<OperationProvider>(builder: (context, op, child) {
      return FutureBuilder(
        future: op.requestCameraPermission(),
        //future: _future,
        builder: (context, snapshot) {
          return SafeArea(
            child: Stack(
              children: [
                if (op.isCameraPermissionGranted)
                  OrientationBuilder(builder: (context, orientation) {
                    // if (MediaQuery.of(context).orientation == Orientation.landscape) {
                    //   SystemChrome.setPreferredOrientations([
                    //     DeviceOrientation.portraitDown,
                    //     DeviceOrientation.portraitUp,
                    //   ]);
                    // } else {
                    //   SystemChrome.setPreferredOrientations([
                    //     DeviceOrientation.landscapeLeft,
                    //     DeviceOrientation.landscapeRight,
                    //   ]);
                    // }
                    return FutureBuilder<List<CameraDescription>>(
                        future: availableCameras(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _initCameraController(snapshot.data!);
                            return Stack(
                              children: [
                                // CameraPreview(_cameraController!),
                                AspectRatio(
                                  aspectRatio: orientation == Orientation.portrait ? 0.55 : 1.3,
                                  child: CameraPreview(_cameraController!),
                                ),
                                captureImgFile != null
                                    ? Positioned.fill(
                                        child: Image.file(
                                        File(captureImgFile!.path),
                                        fit: BoxFit.cover,
                                      ))
                                    : Material(
                                        child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(color: Colors.white),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                   
                                                    Text(
                                                      'Date :',
                                                      style: TextStyle(fontSize: 17, color: Colors.black),
                                                    ),
                                                    Text(
                                                      '${DateConverter.formatDate(DateTime.now())}',
                                                      style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 108, 104, 104)),
                                                    ),
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
                        });
                  }),
                Scaffold(
                  backgroundColor: op.isCameraPermissionGranted ? Colors.transparent : null,
                  body: op.isCameraPermissionGranted
                      ? Column(
                          children: [
                            Expanded(child: Container()),
                            Container(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                  children: [
                                     IconButton(
                                    onPressed: () {
                                      backFromCamera();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                    captureImgFile == null
                                        ? ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                )),
                                            icon: Icon(Icons.camera),
                                            onPressed: captureImg,
                                            label: const Text('Capture'),
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              setState(() {
                                                captureImgFile = null;
                                              });
                                            },
                                            child: Text(
                                              'Retry',
                                              style: TextStyle(color: Colors.white),
                                            )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    captureImgFile != null
                                        ? TextButton(
                                            onPressed: () {
                                              _scanImage(pictureFile: captureImgFile!);
                                            },
                                            child: Text('OK', style: TextStyle(color: Colors.white)))
                                        : SizedBox.shrink()
                                  ],
                                )),
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
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.auto);

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

  captureImg() async {
    try {
      final img = await _cameraController!.takePicture();
      setState(() {
        captureImgFile = img;
      });
    } catch (e) {
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Steady your camera'),
          ),
        );
    }
  }

  _scanImage({required XFile pictureFile}) async {
    if (_cameraController == null) return;
    final navigator = Navigator.of(context);

    try {
      CameraDataModel cameraDataModel = CameraDataModel();
      // pictureFile = await _cameraController!.takePicture();
      //var s = pictureFile.path;
      // final file = File(pictureFile.path);

      // final appDir = await getApplicationDocumentsDirectory(); // Or any other directory you prefer
      // final uniqueFileName = DateTime.now().microsecondsSinceEpoch;
      // final savedImage = File('${appDir.path}/$uniqueFileName.jpg');
      // await savedImage.writeAsBytes(await pictureFile.readAsBytes());
      // //var s= file.toString();
      // final byte = file.readAsBytesSync();

      cameraDataModel = CameraDataModel(
        //pictureFile: pictureFile,
        xpictureFile: pictureFile,
        //imgByte: byte,
        //pictureFile: savedImage,
      );

      navigator.pop(cameraDataModel);
      // navigator.pop(pictureFile);
      //await navigator.push(MaterialPageRoute(builder: (BuildContext context) => ResultScreen(text: recognizedText.text)));
    } catch (e) {
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Steady your camera'),
          ),
        );
    }
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
