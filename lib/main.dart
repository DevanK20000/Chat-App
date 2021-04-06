import 'package:chat_app_college_project/helpers/authenticate.dart';
import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:chat_app_college_project/views/chatroom.dart';
import 'package:chat_app_college_project/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white.withOpacity(0),
  ));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool userLoggedIn;

  @override
  void initState() {
    getLogedInState();
    super.initState();
  }

  getLogedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              backgroundColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: userLoggedIn
                ? userLoggedIn
                    ? ChatRoom()
                    : Authenticate()
                : loading(),
          );
        }
        return loading();
      },
    );
  }
}
