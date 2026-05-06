import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final Widget child;
  final String value;

  const AppBadge({Key? key, required this.child, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topRight, children: [child, CircleAvatar(radius: 10, child: Text(value, style: const TextStyle(fontSize: 10)))]);
  }
}
