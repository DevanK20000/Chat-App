import 'package:chat_app_college_project/helpers/authenticate.dart';
import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:chat_app_college_project/services/auth.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/views/search.dart';
import 'package:chat_app_college_project/widgets/chatroomtile.dart';
import 'package:chat_app_college_project/widgets/loading.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethod _authMethod = new AuthMethod();
  DataBaseMethod _dataBaseMethod = new DataBaseMethod();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      // initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData && snapshot != null
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      snapshot.data.docs[index]
                          .data()["chatroomid"]
                          .toString()
                          .replaceAll(Constants.myName, " ")
                          .replaceAll("_", " "),
                      snapshot.data.docs[index].data()["chatroomid"]);
                },
              )
            : loading();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
    // print(Constants.myName);
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    _dataBaseMethod.getChatRoom(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat App',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
          ),
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              _authMethod.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(4, 20, 4, 0),
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          color: Color(0xFF3d4049),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: chatRoomList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Search())),
        child: Icon(Icons.message),
      ),
    );
  }
}
