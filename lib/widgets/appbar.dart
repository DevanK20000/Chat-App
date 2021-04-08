import 'package:flutter/material.dart';

Widget appbarmain(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 30,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.blue, //change your color here
    ),
    brightness: Brightness.light,
    backgroundColor: Colors.white.withOpacity(0),
    elevation: 0,
  );
}
