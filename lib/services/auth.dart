import 'package:chat_app_college_project/helpers/constants.dart';
import 'package:chat_app_college_project/helpers/helperfunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_college_project/models/users.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Users _userFromFirebaseUser(UserCredential user) {
    return user != null
        ? Users(
            displayName: user.user.displayName,
            email: user.user.email,
            photoURL: user.user.photoURL,
            emailVerified: user.user.emailVerified,
            userId: user.user.uid,
          )
        : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserCredential firebaseUser = result;
      Constants.uid = result.user.uid;
      Constants.myEmail = result.user.email;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserCredential firebaseUser = result;
      Constants.uid = result.user.uid;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future addAditionalData(String username, String photoURL) async {
    try {
      await _auth.currentUser
          .updateProfile(displayName: username, photoURL: photoURL);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      HelperFunctions.saveUserEmailSharedPreference(null);
      HelperFunctions.saveUserNameSharedPreference(null);
      HelperFunctions.saveUidSharedPreference(null);
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
