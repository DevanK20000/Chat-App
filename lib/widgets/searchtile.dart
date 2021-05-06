import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {
  final String userName;
  final String email;
  final String toUid;
  final String imageURL;
  final Function onMessage;
  SearchTile(
      {this.userName, this.email, this.toUid, this.onMessage, this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Color(0xff2a2d36),
      child: ListTile(
        leading: SizedBox(
          height: 60,
          width: 60,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: imageURL == "" || imageURL == null
                ? Icon(Icons.person_outline_sharp)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        imageUrl: imageURL,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        fit: BoxFit.cover),
                  ),
          ),
        ),
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
            onMessage(toUid, userName, imageURL);
          },
        ),
      ),
    );
  }
}
