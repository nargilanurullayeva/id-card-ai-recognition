import 'dart:ffi';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/upload.dart';

File? selectedImage;
String? message = "";

String url1 = 'http://192.168.1.108:5000/name'; // phone
String url2 = 'http://10.0.2.2:5000/name'; // emulator

int? id_number;
String surname = "", name = "", gender = "", b_day = "";
List<String>? dataList;
Map<String, String> map = Map();
final _userName = TextEditingController();

/// one screen to another screen
class UploadData {
  File? imageFile;
  Map<String, String>? map;

  UploadData({this.imageFile, this.map});
}

bool isUpperCase(String str) {
  return str == str.toUpperCase();
}

bool containsNumber(String str) {
  RegExp regex = RegExp(r'\d');
  return regex.hasMatch(str);
}

uploadImage() async {
  map.clear();
  id_number = 0;
  surname = "";
  name = "";
  gender = "";
  b_day = "";

  final request = http.MultipartRequest('POST', Uri.parse(url1));
  request.files
      .add(await http.MultipartFile.fromPath('image', selectedImage!.path));
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  final message = jsonDecode(utf8.decode(response.bodyBytes));
  if (response.statusCode == 200) {
    print('Image uploaded successfully');
    final data = (message["data"] as List).map((e) => e as String).toList();

    // Yazi Parcalama
    int i = 0;
    while (i < data.length) {
      var item = data[i].replaceAll(RegExp('[^A-Za-z0-9-.]'), ' ');

      // TC kimlik Okuma
      if (int.tryParse(item) != null && item.length == 11) {
        id_number = int.parse(item);
      }

      // Ad Soyad Okuma
      if (isUpperCase(item) &&
          id_number != 0 &&
          !item.contains('.') &&
          !containsNumber(item) &&
          item.length > 1) {
        if (surname != "" && name == "") {
          name = item;
        } else if (surname == "") {
          surname = item;
        }
      }

      // Dogum tarihi ve Belge tarihi
      if (containsNumber(item.replaceAll(RegExp('[^z0-9]'), '')) &&
          item.length == 10 &&
          b_day == "") {
        b_day = item;
      }

      // Cinsiyet Okuma
      if (isUpperCase(item) &&
          !containsNumber(item) &&
          (item.replaceAll(' ', '')).length <= 2 &&
          gender == "") {
        gender = item.toString();
      }
      i++;
    }

    map = {
      'id_number': id_number.toString(),
      'name': name.toString(),
      'surname': surname.toString(),
      'gender': gender.toString(),
      'birth_date': b_day.toString(),
    };
    print(map);
    return true;
    // ekle(selectedImage!, map);
    // readCardDb();
  } else if (message["status"] == "failed") {
    print('Failed to upload image');
    return false;
  }
}

Future getImage() async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath:
        (await ImagePicker().getImage(source: ImageSource.camera))!.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Color.fromARGB(255, 179, 231, 206),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      ),
      /* WebUiSettings(
          context: context,
        ),*/
    ],
  );
  selectedImage = File(croppedFile!.path);
}
