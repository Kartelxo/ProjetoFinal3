import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  final double thickness;
  const AppDivider({Key? key, this.thickness = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) => Divider(thickness: thickness);
}
