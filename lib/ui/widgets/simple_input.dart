import 'package:flutter/material.dart';

class SimpleInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const SimpleInput({Key key, this.label, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "$label",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.amber,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}