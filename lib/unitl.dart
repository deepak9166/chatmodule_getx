import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

Future<File> getImagePicker({bool isCamra = false}) async {
  if (isCamra) {
    return getImageFromCamra();
  } else {
    return getFilePicker();
  }
}

Future<File> getImageFromCamra() async {
  File image;
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    image = File(pickedFile.path);
  } else {
    print('No image selected.');
  }
  return image;
}

Future<File> getFilePicker({bool isCamra = false}) async {
  FilePickerResult result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path);

    return file;
  } else {
    // User canceled the picker
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

messageLoader() {
  return Center(
      child: Stack(
    alignment: Alignment.center,
    children: [
      Image.network(
        "https://media.tenor.com/images/817596d6626736251eea50f61b9492a4/tenor.gif",
        height: 28,
        width: 28,
      ),
      // CircularProgressIndicator(),
    ],
  ));
}

void launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
