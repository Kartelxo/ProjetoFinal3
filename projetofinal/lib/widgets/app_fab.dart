import 'package:flutter/material.dart';

class AppFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const AppFab({Key? key, required this.onPressed, this.icon = Icons.add}) : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton(onPressed: onPressed, child: Icon(icon));
}
