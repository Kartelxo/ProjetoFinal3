import 'package:flutter/material.dart';

class AppPlaceholder extends StatelessWidget {
  final double height;
  final String? text;

  const AppPlaceholder({Key? key, this.height = 80, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(height: height, color: Colors.grey.shade200, child: Center(child: Text(text ?? 'Placeholder')));
}
