import 'package:firebase_auth/firebase_auth.dart';
import 'package:sticky_notes/constant.dart';

class FirebaseServices {
  static Future<bool> signUp(String email, String password) async {
    try {
      await kFirebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      print("Error===>>>$e");
      return false;
    }
  }

  static Future<bool> logIn(String email, String password) async {
    try {
      await kFirebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      print("Error===>>>$e");

      return false;
    }
  }

  static Future logOut() async {
    await kFirebaseAuth.signOut();
  }
}
