import "dart:io";
import 'package:flutter/material.dart';
import 'package:heart_disease_prediction/home.dart';
import 'package:heart_disease_prediction/urban.dart';
import 'package:heart_disease_prediction/auth_controller.dart';

class MyChoice extends StatefulWidget {
  const MyChoice({Key? key}) : super(key: key);

  @override
  State<MyChoice> createState() => _MyChoiceState();
}

class _MyChoiceState extends State<MyChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage('assets/register.png'), fit:BoxFit.cover)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img.png',
                  width: 170,
                  height: 150,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHome(),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Card(
                      color: Color(0xff4c505b),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Heart Disease Prediction',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/img_2.png',
                  width: 250,
                  height: 170,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyUrban(),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Card(
                      color: Color(0xff4c505b),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Urban Sound Prediction',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  child: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: Color(0xff4c505b),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    AuthController.instance.logOut();
                    print('Logout');
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}