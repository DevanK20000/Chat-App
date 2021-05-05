import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/views/profile.dart';
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
  // AuthMethod _authMethod = new AuthMethod();
  DataBaseMethod _dataBaseMethod = new DataBaseMethod();
  Stream chatRoomStream;
  String userImageURl;

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
                          .replaceAll(Constants.uid, "")
                          .replaceAll("_", "")
                          .toString(),
                      snapshot.data.docs[index].data()["LastMessage"],
                      snapshot.data.docs[index].data()["SendBy"],
                      snapshot.data.docs[index].data()["deletefor"],
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
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.uid = await HelperFunctions.getUidSharedPreference();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    _dataBaseMethod.getUserByUid(Constants.uid).then((value) {
      setState(() {
        Constants.imageUrl = value.docs[0].data()["imageurl"];
        Constants.bio = value.docs[0].data()["bio"];
      });
    });
    _dataBaseMethod.getChatRoom(Constants.uid).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
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
          Hero(
            tag: 'profile',
            child: GestureDetector(
              onTap: () {
                Constants.imageUrl != null
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()))
                    : print("wait");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 35,
                  width: 35,
                  child: CircleAvatar(
                    // backgroundColor: Colors.white,
                    radius: 30,
                    child:
                        Constants.imageUrl == "" || Constants.imageUrl == null
                            ? Icon(Icons.person_outline_sharp)
                            : SizedBox(
                                height: 30,
                                width: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: CachedNetworkImage(
                                    imageUrl: Constants.imageUrl,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                  ),
                ),
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
