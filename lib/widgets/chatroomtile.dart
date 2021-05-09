import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/views/conversation.dart';
import 'package:flutter/material.dart';

class ChatRoomTile extends StatefulWidget {
  final String uid;
  final String chatroomid;
  final String lastmsg;
  final String sendBy;
  final String deleteFor;
  ChatRoomTile(
      this.uid, this.lastmsg, this.sendBy, this.deleteFor, this.chatroomid);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  DataBaseMethod _dataBaseMethod = new DataBaseMethod();
  String username;
  String imageUrl;
  String lastMessage;
  String bio;
  String email;

  @override
  void initState() {
    getResDetail(widget.uid);
    super.initState();
  }

  getResDetail(String uid) async {
    _dataBaseMethod.getUserByUid(uid).then((value) {
      setState(() {
        username = value.docs[0].data()["user"];
        imageUrl = value.docs[0].data()["imageurl"];
        bio = value.docs[0].data()["bio"];
        email = value.docs[0].data()["email"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(
                  widget.chatroomid, username, imageUrl, bio, email),
            ),
          );
        },
        child: ListTile(
          // contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          leading: Hero(
            tag: email != null ? email : 'loading',
            child: SizedBox(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: imageUrl == "" || imageUrl == null
                    ? Icon(Icons.person_outline_sharp)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                            height: 100,
                            width: 100,
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            fit: BoxFit.cover),
                      ),
              ),
            ),
          ),
          title: Text(
            username != null ? username : "Loading",
            style: TextStyle(color: Colors.blue),
          ),
          subtitle: Text(
              widget.deleteFor == "all" || widget.deleteFor == Constants.uid
                  ? "Message deleted"
                  : widget.lastmsg),
        ),
      ),
    );
  }
}
