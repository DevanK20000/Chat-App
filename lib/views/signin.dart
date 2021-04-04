import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:chat_app_college_project/widgets/buttons.dart';
import 'package:flutter/material.dart';

class Signn extends StatefulWidget {
  Signn({Key key}) : super(key: key);

  @override
  _SignnState createState() => _SignnState();
}

class _SignnState extends State<Signn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context),
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
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
            signinwithemail(),
            SizedBox(height: 10),
            signinwithgoogle(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {},
                  child: Text('Register now'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
