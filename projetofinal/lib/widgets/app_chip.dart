import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  final String label;
  const AppChip({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
