import 'package:flutter/material.dart';

class AppRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const AppRadio({Key? key, required this.value, required this.groupValue, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) => Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged);
}
