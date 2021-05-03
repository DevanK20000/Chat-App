import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String userImageURL;
  EditProfile(this.userImageURL);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DataBaseMethod _dataBaseMethod = new DataBaseMethod();
  final formLogInKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController bioTextEditingController = new TextEditingController();

  @override
  void initState() {
    _initVales();
    super.initState();
  }

  _initVales() {
    usernameTextEditingController.text = Constants.myName;
    // _dataBaseMethod.getUserByUid(Constants.uid).then((value) {
    //   setState(() {
    //     usernameTextEditingController.text = value.docs[0].data()["user"];
    //   });
    // });
  }

  _updatePRofile() async {
    if (formLogInKey.currentState.validate()) {
      if (Constants.myName != usernameTextEditingController.text) {
        Map<String, String> _updateInfoMap = {
          "user": usernameTextEditingController.text,
        };
        _dataBaseMethod.updateProfile(_updateInfoMap).then((value) {
          setState(() {
            Constants.myName = usernameTextEditingController.text;
          });
          HelperFunctions.saveUserNameSharedPreference(
              usernameTextEditingController.text);

          Navigator.popUntil(context, (route) => route.isFirst);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context, 'Edit'),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 12),
              Center(
                child: Hero(
                  tag: 'profile',
                  child: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: CircleAvatar(
                          // backgroundColor: Colors.white,
                          radius: 30,
                          child: widget.userImageURL == "" ||
                                  widget.userImageURL == null
                              ? Icon(Icons.person_outline_sharp)
                              : SizedBox(
                                  height: 147,
                                  width: 147,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      fit: StackFit.expand,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: widget.userImageURL,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          fit: BoxFit.fitWidth,
                                        ),
                                        CircleAvatar(
                                          backgroundColor:
                                              Colors.blueGrey.withOpacity(0.5),
                                          radius: 30,
                                        ),
                                        Icon(Icons.edit_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: formLogInKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      validator: (val) => val.isEmpty || val.length < 4
                          ? 'Plese provide an valid username'
                          : null,
                      controller: usernameTextEditingController,
                      maxLength: 16,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Change Username',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) => val.isEmpty || val.length < 4
                          ? 'Bio should be more than 4 letters'
                          : null,
                      // controller: usernameTextEditingController,
                      maxLength: 100,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Bio',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _updatePRofile,
                      child: Text("Update Profile"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
