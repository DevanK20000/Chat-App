import 'package:chat_app_college_project/helpers/authenticate.dart';
import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_college_project/views/editProfile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chat_app_college_project/services/auth.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final AuthMethod _authMethod = new AuthMethod();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context, 'Profile'),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 12),
              Center(
                child: Hero(
                  tag: 'profile',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: CircleAvatar(
                        radius: 30,
                        child: Constants.imageUrl == "" ||
                                Constants.imageUrl == null
                            ? Icon(Icons.person_outline_sharp)
                            : SizedBox(
                                height: 147,
                                width: 147,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
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
              ),
              SizedBox(height: 8),
              Text(
                Constants.myName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 4),
              Text(
                Constants.myEmail,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                Constants.bio,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text("Edit Profile"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile())),
                    ),
                    ListTile(
                      leading: Icon(Icons.mail_outline_rounded),
                      title: Text("Change Password"),
                      onTap: () => _authMethod.resetPass(Constants.myEmail),
                    ),
                  ],
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("about"),
                  leading: Icon(Icons.error_outline_rounded),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon: Icon(
                        Icons.message_outlined,
                        color: Colors.blue,
                        size: 50,
                      ),
                      applicationVersion: '1.0',
                      applicationLegalese: '© 2021',
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text("VESIT, Kurla"),
                          subtitle: Text("MAC sem-1 project"),
                          leading: Icon(
                            Icons.school,
                            size: 35,
                          ),
                          onTap: () => _launchURL('https://vesit.ves.ac.in/'),
                        ),
                        Text("By Students:"),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text("Devan Khandagale"),
                          subtitle: Text("Roll no: 26"),
                          onTap: () =>
                              _launchURL('https://github.com/DevanK20000'),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text("Arya Varma"),
                          subtitle: Text("Roll no: 59"),
                          onTap: () =>
                              _launchURL('https://github.com/aryavarma'),
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () {
                    _authMethod.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Authenticate()),
                        (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
