import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final Widget child;
  const AppFooter({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), child: child);
}
