import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.suffixPressed,
    this.suffixIcon,
    required this.hintText,
    required this.validator,
    required this.controller,
    this.onTap,
  }) : super(key: key);
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final GestureTapCallback? onTap;
  final VoidCallback? suffixPressed;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.text,
      cursorColor: Colors.red,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        fillColor: Colors.grey.shade200,
        suffixIcon:
            IconButton(onPressed: suffixPressed, icon: Icon(suffixIcon)),
        filled: true,
        contentPadding: const EdgeInsets.all(10.0),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent)),
      ),
    );
  }
}
