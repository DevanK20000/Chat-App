import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class DataBaseMethod {
  uploadUserInfo(userMap, String uid) {
    FirebaseFirestore.instance.collection("users").doc(uid).set(userMap);
  }

  Future updateProfile(updateMap) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.uid)
        .update(updateMap);
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

  Future getUserByUid(String uid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
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

  addLastMessage(String chatRoomId, lastMessageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .update(lastMessageMap)
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

  Future getLastMessage(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .get();
  }

  getChatRoom(String myUID) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("usersUid", arrayContains: myUID)
        .snapshots();
  }

  deleteMessage(AsyncSnapshot snapshot, int index, String chatroomid) async {
    Map<String, String> del;
    del = {
      "deletefor": "all",
    };
    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(snapshot.data.docs[index].reference);
    });
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatroomid)
        .update(del)
        .catchError((e) {
      print(e);
    });
  }

  deleteMessageOnlyMe(
      AsyncSnapshot snapshot, int index, data, String chatroomid) async {
    if (snapshot.data.docs[index].data()["deletefor"] == "none") {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
            snapshot.data.docs[index].reference, data, SetOptions(merge: true));
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(chatroomid)
          .update(data)
          .catchError((e) {
        print(e);
      });
    } else {
      deleteMessage(snapshot, index, chatroomid);
    }
  }

  // deletforLastmessage(String chatroomid, lastMessageMap) {
  //   FirebaseFirestore.instance
  //       .collection("ChatRoom")
  //       .doc(chatroomid)
  //       .update(lastMessageMap)
  //       .catchError(
  //     (e) {
  //       print(e);
  //     },
  //   );
  // }
}
