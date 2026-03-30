import 'package:flutter/material.dart';

class PrimaryContentText extends StatelessWidget {
  const PrimaryContentText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 16));
  }
}

class SecondaryContentText extends StatelessWidget {
  const SecondaryContentText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 14));
  }
}
