import 'package:flutter/material.dart';

void showSnackBer(BuildContext context, String message, Duration? duration){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content:Text(message),
      duration: duration ?? const Duration(seconds: 2),
  ),
  );
}