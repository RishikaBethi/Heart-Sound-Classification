import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "dart:io";
import 'package:heart_disease_prediction/home.dart';
import 'package:heart_disease_prediction/otp.dart';
import 'package:heart_disease_prediction/phone.dart';
import 'package:heart_disease_prediction/features.dart';
import 'package:heart_disease_prediction/login.dart';
import 'package:heart_disease_prediction/register.dart';
import 'package:heart_disease_prediction/choice.dart';
import 'package:heart_disease_prediction/urban.dart';
import 'package:heart_disease_prediction/auth_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
      routes:{
      'phone': (context) => MyPhone(),
      'otp': (context) => MyOtp(),
      'login':(context)=> MyLogin(),
      'register':(context)=> MyRegister(),
      'choice':(context)=> MyChoice(),
      'home': (context) => MyHome(),
      'urban':(context)=> MyUrban(),
      'features': (context) => MyFeatures(audioFilePath: ModalRoute.of(context)?.settings.arguments as String?),
      },
  ));
}