import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Function() onPress;
  final bool loading; // New optional parameter

  const MyButton({
    Key? key,
    required this.text,
    this.color,
    required this.onPress,
    this.loading = false, // Initialize the optional parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        color: color ?? Theme.of(context).primaryColor,
        height: 42,
        elevation: 0,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        onPressed: loading ? () {} : onPress, // Disable button when loading is true
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading) // Display loader only when loading is true
              SizedBox(
                width: 14, // Fixed width for the circular progress indicator
                height: 14,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).scaffoldBackgroundColor),
                  strokeWidth: 2,
                ),
              ),
            SizedBox(width: loading ? 10 : 0), // Spacer if loading
            Text(
              text,
              style: TextStyle(fontSize: 14, color: Theme.of(context).scaffoldBackgroundColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
