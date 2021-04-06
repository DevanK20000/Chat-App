import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethod {
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  Future getUsersByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("user", isEqualTo: username)
        .get();
  }

  Future getUsersByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}