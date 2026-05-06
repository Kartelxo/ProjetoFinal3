import 'package:flutter/material.dart';

class AppExpansionTile extends StatelessWidget {
  final Widget title;
  final List<Widget> children;

  const AppExpansionTile({Key? key, required this.title, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) => ExpansionTile(title: title, children: children);
}
