import 'package:flutter/material.dart';

class AppProgress extends StatelessWidget {
  final double? value;

  const AppProgress({Key? key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) => value == null ? const CircularProgressIndicator() : LinearProgressIndicator(value: value);
}
