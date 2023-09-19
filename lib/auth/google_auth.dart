import 'package:assignment_test/screens/navigaton_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        if(user!=null){
         FirebaseDatabase.instance.ref().child('users').child(user.uid).update({'email':user.email}).then((value) {
           Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const NavigationBarScreen()));
         });
          
        }
      } on FirebaseAuthException catch (e) {
       if (e.code == 'invalid-credential') {
         
        }
      } catch (e) {
      
      }
    }

    return user;
  }
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
    } catch (e) {

    }
  }
}