import 'package:assignment_test/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserDataProvider with ChangeNotifier{

  UserModel? userModel;

updateUserData(UserModel user){
 userModel=user;
 notifyListeners();
}

}