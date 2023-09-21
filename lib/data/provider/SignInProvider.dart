import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SignInProvider extends ChangeNotifier {

  String id = '';
  String password = '';

  Future<bool> reqSignIn() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: id, password: password);
      return true;
    } catch(e) {
      if(e is FirebaseAuthException) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: id, password: password);
          return true;
        } catch(e) {
          return false;
        }
      } else {
        return false;
      }
    }
  }
}