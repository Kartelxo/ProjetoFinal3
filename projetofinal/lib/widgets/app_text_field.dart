import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;

  const AppTextField({Key? key, this.controller, this.hint, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hint, labelText: label, border: const OutlineInputBorder()),
    );
  }
}
