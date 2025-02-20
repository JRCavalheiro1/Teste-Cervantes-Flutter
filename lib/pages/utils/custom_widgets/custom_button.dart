import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  delete,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;

  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor:
              type == ButtonType.delete ? Color(0xFFf03636) : Color(0xFF37abe8),
          foregroundColor: type == ButtonType.delete
              ? Color(0xFFFFFFFF)
              : Color(0xFF000000)),
      child: Text(text),
    );
  }
}
