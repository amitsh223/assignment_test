import 'package:assignment_test/screens/navigaton_bar.dart';
import 'package:assignment_test/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../auth/google_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final currUser = FirebaseAuth.instance.currentUser;
    Future.delayed(Duration(seconds: 2)).then((value) {
      if (currUser == null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => SignInScreen()));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => NavigationBarScreen()));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.blue)),
    ));
  }
}
