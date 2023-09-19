import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';


class DatabaseCall {
  Future updateUserProfileInDatabase(
      UserModel userModel, context) async {
    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users/${userModel.uid}');

    userRef.update({
      'email': userModel.email,
      'name': userModel.name,
      'phoneNo': userModel.phoneNo,
      'age': userModel.age
    }).then((_)async {
      Fluttertoast.showToast(msg: "Updated Successfully");
       var dir= await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
     Box box= await Hive.openBox("userData");
    box.put("userData",{
      'email': userModel.email,
      'name': userModel.name,
      'phoneNo': userModel.phoneNo,
      'age': userModel.age
    } );

    }).catchError((error) {

      log(error.toString());
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  Future getUserData(String userId) async {
    try{
    final userRef = FirebaseDatabase.instance.ref().child('users/$userId');
    final data = await userRef.once();
    if (data.snapshot.value != null) {
      return data.snapshot.value;
    } else {
      log("XXXx");
      return null;
    }}catch(e){
      log(e.toString());
    }
  }
}
