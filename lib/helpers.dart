import 'package:flutter/material.dart';

mySnack(String message, BuildContext context, {bool danger = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: const TextStyle(color: Colors.white)),
    showCloseIcon: true,
    closeIconColor: Colors.white,
    backgroundColor: !danger ? Colors.blue : Colors.pink,
  ));
}
