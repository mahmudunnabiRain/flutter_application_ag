import 'package:flutter/material.dart';

class OutlinedTextField extends StatefulWidget {
  const OutlinedTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.obscureText,
    this.keyboardType,
    this.marginBottom,
    this.isTextArea,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final double? marginBottom;
  final bool? isTextArea;

  @override
  State<OutlinedTextField> createState() => _OutlinedTextFieldState();
}

class _OutlinedTextFieldState extends State<OutlinedTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom ?? 20.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText == true ? _obscureText : false,
        keyboardType: widget.keyboardType,
        maxLines: widget.isTextArea ?? false ? 4 : 1,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(fontSize: 14),
          floatingLabelStyle: const TextStyle(fontSize: 16),
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.all(12),
          suffixIcon: widget.obscureText == true
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
