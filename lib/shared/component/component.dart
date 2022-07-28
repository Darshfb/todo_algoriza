import 'package:flutter/material.dart';

void navigateTo({required BuildContext context, required Widget widget}) =>
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => widget));
