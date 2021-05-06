import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/views/conversation.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:chat_app_college_project/widgets/searchtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchTextEditingController =
      new TextEditingController();

  DataBaseMethod dataBaseMethod = new DataBaseMethod();
  QuerySnapshot searchSnapshot;

  initiateSearch() {
    if (!searchTextEditingController.text.startsWith(" ") &&
        searchTextEditingController.text != "") {
      dataBaseMethod
          .getUsersByUsername(searchTextEditingController.text)
          .then((value) {
        setState(() {
          searchSnapshot = value;
        });
      });
    }
  }

  Widget searchList() {
    if (searchSnapshot != null) {
      if (searchSnapshot.docs.length != 0) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                  toUid: searchSnapshot.docs[index].data()["uid"],
                  userName: searchSnapshot.docs[index].data()["user"],
                  email: searchSnapshot.docs[index].data()["email"],
                  onMessage: createChatRoomAndStartConversation,
                  imageURL: searchSnapshot.docs[index].data()["imageurl"],
                  bio: searchSnapshot.docs[index].data()["bio"]);
            });
      } else {
        return Container(
          child: Center(
            child: Text(
              'No result',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } else {
      return Container(
        child: Center(
          child: Text(
            'Search for username',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  createChatRoomAndStartConversation(String _toUid, String _username,
      String _resImageURL, String _bio, String _email) {
    if (_toUid != Constants.uid) {
      String _chatRoomId = getChatRoomId(_toUid, Constants.uid);
      List<String> usersUid = [_toUid, Constants.uid];
      Map<String, dynamic> _chatRoomMap = {
        "usersUid": usersUid,
        "chatroomid": _chatRoomId,
        "deletefor": "none",
        "LastMessage": "No conversation",
        "sendBy": "",
        "time": DateTime.now().microsecondsSinceEpoch
      };
      dataBaseMethod.createChatRoom(_chatRoomId, _chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                  _chatRoomId, _username, _resImageURL, _bio, _email)));
    } else {
      print("connot chat with yourself");
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context, Constants.appName),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    height: 45,
                    child: TextField(
                      controller: searchTextEditingController,
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                        labelText: "Search for your friends",
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: initiateSearch,
                    child: Icon(Icons.search),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                    color: Color(0xFF3d4049),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: searchList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
