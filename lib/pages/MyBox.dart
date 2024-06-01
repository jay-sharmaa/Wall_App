import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  final String text;
  final String sectionName;
  const MyBox({super.key, required this.text, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sectionName),
          Text(text)
        ],
      ),
    );
  }
}
