import 'dart:developer';
import 'dart:io';

import 'package:assignment_test/database/database_calls.dart';
import 'package:assignment_test/models/user_model.dart';
import 'package:assignment_test/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import '../Utils/utils.dart';
import '../providers/usermodel_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  UserModel userModel = UserModel();
  updateUserData(UserModel user) async {
    final ref = Provider.of<UserDataProvider>(context, listen: false);
    ref.updateUserData(user);
    userModel = ref.userModel!;
    nameController.value = TextEditingValue(text: userModel.name!);
    emailController.value = TextEditingValue(text: userModel.email!);
    phoneNumberController.value = TextEditingValue(text: userModel.phoneNo!);
    ageController.value = TextEditingValue(text: userModel.age!);
  }

  Box? box;
  openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox("userData");
    return;
  }

 

  checkForOnline() async {
    bool isOnline = await Utils().hasNetwork();
    if (!isOnline) {
      await openBox();
      final data = box!.get("userData");
      UserModel userModel = UserModel(
          email: data['email'],
          age: data['age'],
          name: data['name'],
          phoneNo: data['phoneNo']);
          updateUserData(userModel);
    }
  }

  @override
  void initState() {
    checkForOnline();
    DatabaseCall()
        .getUserData(FirebaseAuth.instance.currentUser!.uid)
        .then((value) {
      if (value != null) {
        updateUserData(UserModel(
            age: value['age'],
            email: FirebaseAuth.instance.currentUser!.email,
            phoneNo: value['phoneNo']??'',
            name: value['name']??''));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                enabled: false,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone Number is required';
                  }else if(value.length==10){
                    return null;
                  }
                 
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Age is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Age must be a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = nameController.text;
                    final email = emailController.text;
                    final phoneNumber = phoneNumberController.text;
                    final age = ageController.text;
                    FocusScope.of(context).unfocus();
                    DatabaseCall().updateUserProfileInDatabase(
                        UserModel(
                            age: age,
                            email: email,
                            name: name,
                            phoneNo: phoneNumber,
                            uid: FirebaseAuth.instance.currentUser!.uid),
                        context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
