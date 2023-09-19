import 'package:assignment_test/screens/profile_screen.dart';
import 'package:assignment_test/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../auth/google_auth.dart';
import 'home_screen.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
 
 List<BottomNavigationBarItem> items=[
 const BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
 const BottomNavigationBarItem(icon:  Icon(Icons.perm_identity),label: 'Profile')
 ];

 
 int currIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: items,currentIndex: currIndex,onTap: (val){
        setState(() {
          currIndex=val;
        });
      }),
      body:currIndex==0? const HomeScreen(): const ProfileScreen()
    );
  }
}