import 'dart:io';

import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod {
  Future uploadImage(File image) async {
    return FirebaseStorage.instance
        .ref()
        .child("user_image")
        .child(Constants.uid + ".png")
        .putFile(image);
  }

  Future downloadURL() async {
    return await FirebaseStorage.instance
        .ref()
        .child("user_image")
        .child(Constants.uid + ".png")
        .getDownloadURL();
  }
}
