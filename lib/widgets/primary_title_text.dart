import 'package:flutter/material.dart';

class PrimaryTitleText extends StatelessWidget {
  const PrimaryTitleText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

class SecondaryTitleText extends StatelessWidget {
  const SecondaryTitleText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
