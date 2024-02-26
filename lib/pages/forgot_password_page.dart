import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my-textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  final Function()? onTap;
  const ForgotPasswordPage({
    super.key,
    required this.onTap,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(content: Text('Password reset link sent'));
          });
    } on FirebaseAuthException catch (e) {
      print(e);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(e.message.toString()));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'reset password',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 25),
          //username textfield
          MyTextField(
            controller: _emailController,
            hintText: 'Email',
            obscureText: false,
          ),
// add  extra validation for the onclick
          MaterialButton(
            onPressed:
             passwordReset,
            child: const Text('RESET PASSWORD'),
          )
        ],
      ),
    );
  }
}
