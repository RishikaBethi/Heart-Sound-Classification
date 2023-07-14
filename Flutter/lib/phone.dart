import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  static String verify="";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countrycode=TextEditingController();
  var phone="";

  void initState(){
    countrycode.text="+91 ";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/login.png'), fit:BoxFit.cover)),
          child: Container(
              margin: EdgeInsets.only(left: 25,right: 25),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img_1.png',
                        width: 170,
                        height: 170,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Phone Verification',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'We need to register your phone before getting started !',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Colors.grey
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                controller: countrycode,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                  fontSize: 33,
                                  color: Colors.grey
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value){
                                    phone=value;
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Phone'
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: ()async{
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: '${countrycode.text+phone}',
                                verificationCompleted: (PhoneAuthCredential credential) {},
                                verificationFailed: (FirebaseAuthException e) {},
                                codeSent: (String verificationId, int? resendToken) {
                                  MyPhone.verify=verificationId;
                                  Navigator.pushNamed(context, 'otp');
                                },
                                codeAutoRetrievalTimeout: (String verificationId) {},
                              );
                            },
                            child: Text(
                                'Send the code'
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff4c505b),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                          )
                      ),
                      SizedBox(
                        height:30,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'login');
                          },
                          child: Text(
                            'Sign In using Email',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                              color: Color(0xff4c505b),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              )
          ),
      )
    );
  }
}