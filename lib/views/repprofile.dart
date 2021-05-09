import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:flutter/material.dart';

class RepProfile extends StatelessWidget {
  final String username;
  final String bio;
  final String imageURL;
  final String email;
  const RepProfile(this.username, this.bio, this.imageURL, this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context, 'Profile'),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 12),
              Center(
                child: Hero(
                  tag: email,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: CircleAvatar(
                        // backgroundColor: Colors.white,
                        radius: 30,
                        child: imageURL == "" || imageURL == null
                            ? Icon(Icons.person_outline_sharp)
                            : SizedBox(
                                height: 147,
                                width: 147,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: CachedNetworkImage(
                                    imageUrl: imageURL,
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
              ),
              SizedBox(height: 12),
              Text(
                username,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                bio,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
