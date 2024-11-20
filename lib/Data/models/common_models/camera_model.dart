import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';

class CameraDataModel {
  final File? pictureFile;
  final XFile? xpictureFile;
  final Uint8List? imgByte;
  final String? recognizedText;
  final double? latitude;
  final double? longitude;

  CameraDataModel({
    this.pictureFile,
    this.recognizedText,
    this.imgByte,
    this.xpictureFile,
    this.latitude,
    this.longitude,
  });
}
