import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethod {
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  getUsersByUsername(String username) {
    FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }
}
