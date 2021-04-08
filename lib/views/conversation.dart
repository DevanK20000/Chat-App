import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:chat_app_college_project/widgets/loading.dart';
import 'package:chat_app_college_project/widgets/message.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String username;
  ConversationScreen(this.chatRoomId, this.username);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DataBaseMethod dataBaseMethod = new DataBaseMethod();
  TextEditingController messageTextEditingController =
      new TextEditingController();

  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      // initialData: initialData ,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                // reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    snapshot.data.docs[index].data()["message"],
                    snapshot.data.docs[index].data()["sendBy"] ==
                        Constants.myName,
                  );
                },
              )
            : loading();
      },
    );
  }

  sendMessage() {
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageTextEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      dataBaseMethod.addConversationMessage(widget.chatRoomId, messageMap);
      messageTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    dataBaseMethod.getConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context, widget.username),
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Stack(
                //TODO optimize this
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    // height: 45
                    padding: EdgeInsets.only(right: 30),
                    child: TextField(
                      scrollPadding: EdgeInsets.only(right: 30),
                      autocorrect: true,
                      controller: messageTextEditingController,
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                        hintText: "Message...",
                        // labelText: "Say Hello",
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: sendMessage,
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
