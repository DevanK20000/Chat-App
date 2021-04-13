import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/services/database.dart';
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
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.docs.length,
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    if (snapshot.data.docs[index].data()["deletefor"] !=
                        Constants.uid) {
                      return GestureDetector(
                        onLongPress: () {
                          _showMyDialog(
                            snapshot: snapshot,
                            index: index,
                            message:
                                snapshot.data.docs[index].data()["message"],
                            sendBy: snapshot.data.docs[index].data()["sendBy"],
                          );
                        },
                        child: MessageTile(
                          snapshot.data.docs[index].data()["message"],
                          snapshot.data.docs[index].data()["sendBy"] ==
                              Constants.myName,
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 0,
                        width: 0,
                      );
                    }
                  },
                )
              : loading();
        });
  }

  sendMessage() {
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "deletefor": "none",
        "message": messageTextEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      dataBaseMethod.addConversationMessage(widget.chatRoomId, messageMap);
      Map<String, dynamic> lastMessageMap = {
        "deletefor": "none",
        "LastMessage": messageTextEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      dataBaseMethod.addLastMessage(widget.chatRoomId, lastMessageMap);
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

  Future _showMyDialog(
      {String message,
      String sendBy,
      AsyncSnapshot snapshot,
      int index}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to delete?'),
          content: Text("$sendBy : $message"),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Only me'),
              onPressed: () {
                Map<String, String> del;
                del = {
                  "deletefor": Constants.uid,
                };
                // dataBaseMethod.deletforLastmessage(widget.chatRoomId, del);
                dataBaseMethod.deleteMessageOnlyMe(
                    snapshot, index, del, widget.chatRoomId);
                Navigator.of(context).pop();
              },
            ),
            sendBy == Constants.myName
                ? TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      dataBaseMethod.deleteMessage(
                          snapshot, index, widget.chatRoomId);
                      Navigator.of(context).pop();
                    },
                  )
                : null,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.username,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 65),
              child: chatMessageList(),
            ),
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
