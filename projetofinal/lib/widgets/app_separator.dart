import 'package:flutter/material.dart';

class AppSeparator extends StatelessWidget {
  final double height;
  const AppSeparator({Key? key, this.height = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
