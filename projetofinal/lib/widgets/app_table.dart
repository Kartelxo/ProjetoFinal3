import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  final List<TableRow> rows;
  const AppTable({Key? key, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) => Table(children: rows);
}
