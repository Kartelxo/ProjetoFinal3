import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;

  const AppNetworkImage({Key? key, required this.url, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) => Image.network(url, width: width, height: height, fit: BoxFit.cover);
}
