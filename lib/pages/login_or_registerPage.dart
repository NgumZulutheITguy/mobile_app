import 'package:flutter/material.dart';
import 'package:mobile_app/pages/register_page.dart';

import 'package:mobile_app/pages/login_page.dart';

class LoginOrregisterPage extends StatefulWidget {
  const LoginOrregisterPage({super.key});

  @override
  State<LoginOrregisterPage> createState() => _LoginOrregisterPageState();
}

class _LoginOrregisterPageState extends State<LoginOrregisterPage> {

  bool showLoginPage = true;

  void tooglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: tooglePages,
      );
    } else {
      return RegisterPage(
        onTap: tooglePages,
        context: context,
      );
    }
  }
}
