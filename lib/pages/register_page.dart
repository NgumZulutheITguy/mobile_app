import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my-textfield.dart';
import '../components/my_button.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  final BuildContext context;

  RegisterPage({
    Key? key,
    required this.onTap,
    required this.context,
  }) : super(key: key);

  final fullnameController = TextEditingController();
  final rolenameController = TextEditingController();
  final emailController = TextEditingController();
  final createpasswordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  void signUserUp() async {
    // Sign up method
    try {
      // Check if password is confirmed
      if (createpasswordController.text == confirmpasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: createpasswordController.text,
        );
        //add users
        FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.email)
            .set({
          'username': emailController.text.split('@')[0],
          "name": fullnameController.text,
          'role': rolenameController.text,
        });
      } else {
        // Show error message
        showErrorMessage(context, "Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      // Wrong credentials
      showErrorMessage(context, e.code);
    }
  }

  // Wrong email message popup
  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.orange,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                // Logo
                const SizedBox(height: 30),
                Text(
                  'Register your new account',
                  style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 50),

                MyTextField(
                  controller: widget.fullnameController,
                  hintText: 'Full Name',
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                // Username textfield
                MyTextField(
                  controller: widget.rolenameController,
                  hintText: 'Role',
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                // Email textfield
                MyTextField(
                  controller: widget.emailController,
                  hintText: 'contra@gmail.com',
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                // Create password textfield
                MyTextField(
                  controller: widget.createpasswordController,
                  hintText: 'Create Password',
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                // Confirm password textfield
                MyTextField(
                  controller: widget.confirmpasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Sign up button
                MyButton(
                  buttonText: 'Register',
                  onTap: widget.signUserUp,
                ),
 const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member?'),
                    const SizedBox(width: 7),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Log in here',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
