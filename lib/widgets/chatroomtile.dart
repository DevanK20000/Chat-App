import 'package:chat_app_college_project/views/conversation.dart';
import 'package:flutter/material.dart';

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatroomid;
  ChatRoomTile(this.username, this.chatroomid);

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
                  builder: (context) =>
                      ConversationScreen(chatroomid, username)));
        },
        child: ListTile(
          // contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          leading: SizedBox(
            height: 40,
            width: 40,
            child: CircleAvatar(
              radius: 30,
              child: FittedBox(
                  child: Text(username.substring(0, 1).toUpperCase())),
            ),
          ),
          title: Text(username),
        ),
      ),
    );
  }
}
