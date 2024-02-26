import 'package:flutter/material.dart';

class MyButton1 extends StatelessWidget {
  final Function()? onTap;
  // ignore: prefer_typing_uninitialized_variables
  final buttonText;

  const MyButton1({
    super.key,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.orange[500],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
