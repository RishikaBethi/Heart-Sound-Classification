import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:heart_disease_prediction/login.dart';
import 'package:heart_disease_prediction/register.dart';
import 'package:heart_disease_prediction/home.dart';
import 'package:flutter/material.dart';
import 'package:heart_disease_prediction/choice.dart';

class AuthController extends GetxController{
  static final AuthController instance=Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  void onReady(){
    super.onReady();
    _user=Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user){
    if(user==null){
      print("login page");
      Get.offAll(()=>MyLogin());
    }
    else{
      Get.offAll(()=>MyChoice());
    }
  }

  void register(String email, password)async{
    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    }
    catch(e){
      Get.snackbar('About User', 'User message',
          backgroundColor: Color(0xff4c505b),
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            'Account creation failed',
            style: TextStyle(
                color:Colors.white
            ),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(
                color: Colors.white
            ),
          )
      );
    }
  }
  void login(String email, password)async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }
    catch(e){
      Get.snackbar('About Login', 'Login message',
          backgroundColor: Color(0xff4c505b),
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            'Login failed',
            style: TextStyle(
                color:Colors.white
            ),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(
                color: Colors.white
            ),
          )
      );
    }
  }
  void logOut()async{
    await auth.signOut();
  }
}