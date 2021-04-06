import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:chat_app_college_project/services/auth.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:chat_app_college_project/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatroom.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignnState createState() => _SignnState();
}

class _SignnState extends State<SignIn> {
  AuthMethod _authMethod = new AuthMethod();
  final formLogInKey = GlobalKey<FormState>();
  bool isLoading = false;

  DataBaseMethod dataBaseMethod = new DataBaseMethod();

  TextEditingController emailLogInTextEditingController =
      new TextEditingController();
  TextEditingController passwordLogInTextEditingController =
      new TextEditingController();

  QuerySnapshot snapshotUserInfo;

  signMeIn() async {
    // dataBaseMethod
    //     .getUsersByUserEmail(emailLogInTextEditingController.text)
    //     .then((value) {
    //   snapshotUserInfo = value;
    //   HelperFunctions.saveUserNameSharedPreference(
    //       snapshotUserInfo.docs[1].data()["name"]);
    // });

    if (formLogInKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      print(emailLogInTextEditingController.text + "This is email");

      await _authMethod
          .signInWithEmailAndPassword(emailLogInTextEditingController.text,
              passwordLogInTextEditingController.text)
          .then((value) {
        if (value != null) {
          dataBaseMethod
              .getUsersByUserEmail(emailLogInTextEditingController.text)
              .then((value) {
            snapshotUserInfo = value;
            // print(snapshotUserInfo.docs[0].data()["user"]);
            HelperFunctions.saveUserNameSharedPreference(
                    value.docs[0].data()["user"])
                .then((val) {
              if (val != null) {
                HelperFunctions.saveUserLoggedInSharedPreference(true);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ChatRoom()));
              }
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formLogInKey,
                  child: Column(
                    children: [
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
                        controller: emailLogInTextEditingController,
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
                        controller: passwordLogInTextEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot password?'),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                signinwithemail(0, signMeIn),
                SizedBox(height: 10),
                signinwithgoogle(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: widget.toggle,
                      child: Text('Register now'),
                    )
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
