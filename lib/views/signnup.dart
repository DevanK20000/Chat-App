import 'dart:io';

import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:chat_app_college_project/services/auth.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/services/storage.dart';
import 'package:chat_app_college_project/views/chatroom.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:chat_app_college_project/widgets/buttons.dart';
import 'package:chat_app_college_project/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formkey = GlobalKey<FormState>();

  File _image;
  String _imageurl;
  final picker = ImagePicker();

  DataBaseMethod dataBaseMethod = new DataBaseMethod();
  AuthMethod authMethod = new AuthMethod();
  StorageMethod _storageMethod = new StorageMethod();
  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController userNumberTextEditingController =
      new TextEditingController();

  signMeUp() async {
    if (formkey.currentState.validate()) {
      if (_image != null) {
        setState(() {
          isLoading = true;
        });

        HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(
            usernameTextEditingController.text);

        await authMethod
            .signUpWithEmailAndPassword(emailTextEditingController.text,
                passwordTextEditingController.text)
            .then((value) async {
          _storageMethod.uploadImage(_image).then((ref) {
            _storageMethod.downloadURL().then((uri) {
              print(uri + " uri");
              _imageurl = uri;
              Map<String, String> userInfoMap = {
                "uid": Constants.uid,
                "user": usernameTextEditingController.text,
                "email": emailTextEditingController.text,
                "imageurl": _imageurl,
                "bio": 'no bio'
              };
              authMethod.addAditionalData(
                  usernameTextEditingController.text, _imageurl);
              dataBaseMethod.uploadUserInfo(userInfoMap, Constants.uid);
              HelperFunctions.saveUidSharedPreference(Constants.uid);
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ChatRoom()));
            });
          });
        });
      }
    }
  }

  Future getImage(bool fromCamera) async {
    final pickedFile = await picker.getImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 600);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImage(false);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImage(true);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context, Constants.appName),
      body: isLoading
          ? loading()
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 80,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: CircleAvatar(
                            radius: 55,
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      _image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Form(
                        key: formkey,
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
                                labelText: 'Username',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: (value) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                            r"{0,253}[a-zA-Z0-9])?)*$")
                                        .hasMatch(value)
                                    ? null
                                    : 'Please provide an valid email id';
                              },
                              keyboardType: TextInputType.emailAddress,
                              controller: emailTextEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (value) => value.length > 6
                                  ? null
                                  : 'Password should be more than 6 charcters',
                              controller: passwordTextEditingController,
                              maxLength: 16,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      signinwithemail(1, signMeUp),
                      SizedBox(height: 10),
                      signinwithgoogle(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Have an account?'),
                          TextButton(
                            onPressed: widget.toggle,
                            child: Text('Login now'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
