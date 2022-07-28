import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({key, required this.text, required this.onPressed,}) : super(key: key);
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 40.0,
      textColor: Colors.white,
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
