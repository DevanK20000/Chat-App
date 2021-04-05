import 'package:chat_app_college_project/views/signin.dart';
import 'package:chat_app_college_project/views/signnup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  Authenticate({Key key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSingnIn = true;

  void toggleView() {
    setState(() {
      showSingnIn = !showSingnIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSingnIn ? SignIn(toggleView) : SignUp(toggleView);
  }
}
