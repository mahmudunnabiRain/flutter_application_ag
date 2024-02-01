import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  const MyProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2));
  }
}
