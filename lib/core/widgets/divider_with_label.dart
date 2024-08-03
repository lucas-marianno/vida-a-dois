import 'package:flutter/material.dart';

class DividerWithLabel extends StatelessWidget {
  final String label;
  const DividerWithLabel({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    double defaultPadding = MediaQuery.of(context).size.width * 0.02;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: defaultPadding),
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text(label),
        ),
        const Expanded(child: Divider()),
        SizedBox(width: defaultPadding),
      ],
    );
  }
}
