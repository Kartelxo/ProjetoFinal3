import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const AppCard({Key? key, required this.child, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(margin: margin, child: child);
  }
}
