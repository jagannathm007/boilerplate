import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:boilerplate/config/app_sessions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final _storage = GetStorage();

class Helper {
  final picker = ImagePicker();

  //check internet connectivity
  Future<bool> isNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }

  //read from storage
  Future<dynamic> read(String name) async {
    dynamic info = await _storage.read(name) ?? '';
    return info != '' ? json.decode(info) : info;
  }

  //write to storage
  Future<dynamic> write(String key, dynamic value) async {
    dynamic object = value != null ? json.encode(value) : value;
    return await _storage.write(key, object);
  }

  //remove a specific key from storage
  removeKey(String key) {
    _storage.remove(key);
  }

  //clean all from storage
  cleanStorage() {
    _storage.erase();
  }

  //raw snack
  toast(String message, Color color) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: color,
      duration: const Duration(milliseconds: 2000),
    );
  }

  //check have nessesary permission
  Future<bool> getPermissionStatus() async {
    bool _locationState = await Permission.location.isGranted;
    bool _cameraState = await Permission.camera.isGranted;
    bool _storageState = await Permission.storage.isGranted;
    bool _microphoneState = await Permission.microphone.isGranted;
    if (_locationState && _cameraState && _storageState && _microphoneState) {
      return true;
    } else {
      return false;
    }
  }

  //image picker
  Future pickImage([ImageSource? source]) async {
    List<File> _selectedFileList = [];
    try {
      XFile? image =
          await picker.pickImage(source: source ?? ImageSource.camera);
      if (image != null) {
        File? croppedImage = await _cropImage(image);
        if (croppedImage != null) {
          File file = File(image.path);
          _selectedFileList.add(file);
          return _selectedFileList;
        } else {
          return _selectedFileList;
        }
      } else {
        return _selectedFileList;
      }
    } catch (e) {
      alertMessage(e.toString());
    }
  }

  //image cropper
  Future<File?> _cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void successMessage(message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2000),
      backgroundColor: Colors.green,
      borderRadius: 3,
      margin: EdgeInsets.zero,
    );
  }

  void errorMessage(message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2000),
      backgroundColor: Colors.redAccent,
      borderRadius: 3,
      margin: EdgeInsets.zero,
    );
  }

  void alertMessage(message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2000),
      backgroundColor: Colors.amber,
      borderRadius: 3,
      margin: EdgeInsets.zero,
    );
  }

  Future<File> imageFromUInit8List(Uint8List imageUInt8List) async {
    Uint8List tempImg = imageUInt8List;
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/signatureImage.jpg').create();
    file.writeAsBytesSync(tempImg);
    return file;
  }

  getTheme() async {
    var themeMode = await read(AppSessions.themeMode);
    if (themeMode != null && themeMode != '') {
      return ThemeMode.light;
    } else {
      if (themeMode == "light") {
        return ThemeMode.light;
      } else {
        return ThemeMode.dark;
      }
    }
  }
}
