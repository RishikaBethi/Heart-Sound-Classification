import 'package:flutter/material.dart';
import 'auth_controller.dart';
import 'package:get/get.dart';
import 'package:heart_disease_prediction/auth_controller.dart';
import 'package:heart_disease_prediction/auth_controller.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'), fit:BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left:35, top:100),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.black, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.5,
                    left: 35,
                    right: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                        Container(
                          child: Column(
                            children: [
                              TextField(
                                controller: emailController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(0xff4c505b),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(0xff4c505b),
                                      ),
                                    ),
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.email,color: Color(0xff4c505b),),
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(0xff4c505b),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(0xff4c505b),
                                      ),
                                    ),
                                    hintText: "Password",
                                    prefixIcon: Icon(Icons.password,color: Color(0xff4c505b),),
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                                GestureDetector(
                                  onTap:(){
                                    AuthController.instance.register(emailController.text.trim(), passwordController.text.trim());
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 25),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff4c505b),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: double.infinity,
                                    height: 60.0,
                                    child: MaterialButton(
                                      onPressed: () {
                                        AuthController.instance.register(emailController.text.trim(), passwordController.text.trim());
                                      },
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, 'login');
                                      },
                                      child: Text('Sign In',
                                          textAlign: TextAlign.left,
                                          style:TextStyle(
                                              decoration: TextDecoration.underline,
                                              fontSize: 14,
                                              color: Colors.black
                                          )
                                      )
                                  ),
                                  TextButton(onPressed: () {
                                    Navigator.pushNamed(context, 'phone');
                                  },
                                      child: Text('Sign In using Phone Number',style:TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 14,
                                          color: Color(0xff4c505b)
                                      )))
                                ],
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
