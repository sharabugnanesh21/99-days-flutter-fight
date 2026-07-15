import 'package:flutter/material.dart';

class OurButton extends StatelessWidget {
  final Function() onPressed;
  const OurButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue,
          border: Border.all(color: Colors.black, width: 1),
        ),
        height: 30,
        width: double.infinity,
        child: Center(child: Text('Login')),
      )
    );
  }
}