import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/services/auth.dart';
import 'package:chat_app_college_project/widgets/appbar.dart';
import 'package:chat_app_college_project/widgets/buttons.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  TextEditingController _emailTextEditingController =
      new TextEditingController();

  AuthMethod _authMethod = new AuthMethod();

  final formLogInKey = GlobalKey<FormState>();

  _sendResetEmail() async {
    if (formLogInKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
    }
    await _authMethod.resetPass(_emailTextEditingController.text).then(
      (value) {
        final snackBar = SnackBar(
          content: Text('Password reset email has been send if email exist'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context, Constants.appName),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 95,
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
                        controller: _emailTextEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(height: 50),
                      passwordReset(_sendResetEmail),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
