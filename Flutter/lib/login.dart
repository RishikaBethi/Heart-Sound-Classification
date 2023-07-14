import 'package:flutter/material.dart';
import 'auth_controller.dart';
import 'package:get/get.dart';
import 'package:heart_disease_prediction/auth_controller.dart';
import 'package:heart_disease_prediction/auth_controller.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit:BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left:35, top:130),
              child: Text(
                'Welcome\nBack',
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
                  children:[
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email,color: Color(0xff4c505b),),
                          border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.password,color: Color(0xff4c505b),),
                          border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                GestureDetector(
                  onTap:(){
                    AuthController.instance.register(emailController.text.trim(), passwordController.text.trim());
                  },
                  child:Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: const Color(0xff4c505b),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: double.infinity,
                    height: 60.0,
                    child: MaterialButton(
                      onPressed: (){
                        AuthController.instance.login(emailController.text.trim(), passwordController.text.trim());
                      },
                      child: Text(
                        "Sign In",
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
                              Navigator.pushNamed(context, 'register');
                            },
                            child: Text('Sign Up',
                                textAlign: TextAlign.left,
                                style:TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    color: Color(0xff4c505b)
                                ))),
                        TextButton(onPressed: () {
                          Navigator.pushNamed(context, 'phone');
                        },
                            child: Text('Sign In using Phone Number',style:TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: Color(0xff4c505b)
                        )))
                      ],
                    )
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
