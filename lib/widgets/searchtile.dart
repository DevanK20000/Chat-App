import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {
  final String userName;
  final String email;
  final String toUid;
  final Function onMessage;
  SearchTile({this.userName, this.email, this.toUid, this.onMessage});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Color(0xff2a2d36),
      child: ListTile(
        title: Text(
          userName,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          email,
          style: TextStyle(color: Colors.white),
        ),
        trailing: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          )),
          child: Text("Message"),
          onPressed: () {
            onMessage(toUid, userName);
          },
        ),
      ),
    );
  }
}
