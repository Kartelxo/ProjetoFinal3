import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final double radius;
  final String? initials;
  final ImageProvider? image;

  const AppAvatar({Key? key, this.radius = 20, this.initials, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image != null) return CircleAvatar(radius: radius, backgroundImage: image);
    return CircleAvatar(radius: radius, child: Text(initials ?? ''));
  }
}
