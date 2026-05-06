import 'package:flutter/material.dart';

class AppGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;

  const AppGrid({Key? key, required this.children, this.crossAxisCount = 2}) : super(key: key);

  @override
  Widget build(BuildContext context) => GridView.count(crossAxisCount: crossAxisCount, children: children, shrinkWrap: true, physics: const NeverScrollableScrollPhysics());
}
