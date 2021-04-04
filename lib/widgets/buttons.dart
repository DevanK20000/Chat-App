import 'package:flutter/material.dart';

Widget signinwithemail() {
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
          alignment: Alignment.center,
          child: Text(
            "Login",
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
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Center(
                  child: Image.asset(
                    'assets/images/google.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Center(
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
