import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controllerVariable;
  final String labelText;
  final String hintText;

  const CustomTextFormField(
      {Key? key,
      required this.controllerVariable,
      required this.labelText,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerVariable,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFF565656)),
          floatingLabelStyle: TextStyle(color: Color(0xFF37abe8)),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF3a3a3a), width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF37abe8), width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Color(0xFF292929)),
    );
  }
}
