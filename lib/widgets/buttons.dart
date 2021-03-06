import 'package:flutter/material.dart';

Widget signinwithemail(int i, Function log) {
  return Container(
    height: 50.0,
    padding: EdgeInsets.zero,
    child: ElevatedButton(
      onPressed: log,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0),
          ),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff374ABE), Color(0xff64B6FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 400.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            i == 0 ? "Login with email " : "Sign up with email",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );
}

Widget signinwithgoogle() {
  return Container(
    height: 50.0,
    padding: EdgeInsets.zero,
    child: ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0),
          ),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff374ABE), Color(0xff64B6FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 400.0, minHeight: 50.0),
          padding: EdgeInsets.symmetric(horizontal: 25),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Image.asset(
                  'assets/images/google.png',
                  height: 30,
                  width: 30,
                ),
              ),
              Spacer(),
              Flexible(
                flex: 2,
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget passwordReset(Function sendResetEmail) {
  return Container(
    height: 50.0,
    padding: EdgeInsets.zero,
    child: ElevatedButton(
      onPressed: sendResetEmail,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0),
          ),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff374ABE), Color(0xff64B6FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 400.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            "Send password reset email",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
