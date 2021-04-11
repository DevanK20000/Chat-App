import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

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

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  getConversationMessage(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRoom(String username) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }

  deleteMessage(AsyncSnapshot snapshot, int index) async {
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(snapshot.data.docs[index].reference);
    });
  }

  deleteMessageOnlyMe(AsyncSnapshot snapshot, int index, data) async {
    if (snapshot.data.docs[index].data()["deletefor"] == null) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
            snapshot.data.docs[index].reference, data, SetOptions(merge: true));
      });
    } else {
      deleteMessage(snapshot, index);
    }
  }
}
