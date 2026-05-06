import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String text;
  const AppHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(12), child: Text(text, style: Theme.of(context).textTheme.titleLarge));
}
