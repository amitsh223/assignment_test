import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../auth/google_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Image.asset('assets/login.jpg'),
          ElevatedButton.icon(
            onPressed: () async {
              Auth.signInWithGoogle(context: context);
            },
            icon: Icon(Icons.key),
            label: Text('Sign in with Google'),
          )
              ],
            ),
        ));
  }
}
