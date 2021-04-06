import 'package:chat_app_college_project/helpers/authenticate.dart';
import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:chat_app_college_project/services/auth.dart';
import 'package:chat_app_college_project/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethod _authMethod = new AuthMethod();

  @override
  void initState() {
    getUserInfo();
    super.initState();
    print(Constants.myName);
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Search())),
        child: Icon(Icons.message),
      ),
    );
  }
}
