import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final ImageProvider image;
  final BoxFit fit;

  const AppImage({Key? key, required this.image, this.fit = BoxFit.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) => Image(image: image, fit: fit);
}
