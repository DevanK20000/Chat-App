import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:chat_app_college_project/services/auth.dart';
import 'package:chat_app_college_project/services/database.dart';
import 'package:chat_app_college_project/views/chatroom.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:chat_app_college_project/widgets/buttons.dart';
import 'package:chat_app_college_project/widgets/loading.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formkey = GlobalKey<FormState>();

  DataBaseMethod dataBaseMethod = new DataBaseMethod();
  AuthMethod authMethod = new AuthMethod();
  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() async {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> userInfoMap = {
        "user": usernameTextEditingController.text,
        "email": emailTextEditingController.text,
      };

      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(
          usernameTextEditingController.text);

      dataBaseMethod.uploadUserInfo(userInfoMap);

      await authMethod
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) => print(value));

      HelperFunctions.saveUserLoggedInSharedPreference(true);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context),
      body: isLoading
          ? loading()
          : SingleChildScrollView(
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
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) => val.isEmpty || val.length < 4
                                  ? 'Plese provide an valid username'
                                  : null,
                              controller: usernameTextEditingController,
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
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
