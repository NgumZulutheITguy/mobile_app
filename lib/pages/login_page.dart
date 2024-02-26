import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my-textfield.dart';
import '../components/my_button.dart';
import '../components/square_tile.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

// show loading circle

  void signUserIn() async {
//sign in method
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      //wrong credentials
      showErrorMessage(e.code);
    }
  }

// wrong emailMassage popup
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.orange,
              title: Center(
                  child: Text(
                message,
                style: const TextStyle(color: Colors.black),
              )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  const SizedBox(height: 50),

                  const SquareTile(
                    imagePath: 'lib/images/contra.png',
                  ),

                  const SizedBox(height: 50),
                  //welcome back you've been missed
                  Text(
                    "Welcome back, let's start working",
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 25),
                  //username textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 15),

                  //password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  //forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgotPasswordPage(
                                onTap: () {},
                              );
                            }));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blue[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  //sign in button
                  MyButton1(onTap: signUserIn, buttonText: 'Sign In'),

                  const SizedBox(height: 50),
                  //or continue with

                  /* Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('OR',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        )),
                  ),

                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SquareTile(
                        imagePath: 'lib/images/google.png',
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),*/

                  // SquareTile(imagePath: 'lib/images/apple.png'),

                  // register now

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No a member?'),
                      const SizedBox(width: 7),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
