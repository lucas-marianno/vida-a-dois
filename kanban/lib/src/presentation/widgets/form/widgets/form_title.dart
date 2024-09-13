import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  final String title;
  final void Function() onIconPressed;
  final IconData? icon;
  final Color? color;

  const FormTitle({
    required this.title,
    required this.onIconPressed,
    required this.icon,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isShittyDevice = MediaQuery.of(context).size.height < 1000;
    return ListTile(
      contentPadding: isShittyDevice ? EdgeInsets.zero : null,
      title: Text(
        title,
        textScaler: TextScaler.linear(isShittyDevice ? 0.7 : 1),
        style: Theme.of(context).textTheme.headlineSmall,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: icon == null
          ? null
          : FilledButton(
              style: FilledButton.styleFrom(backgroundColor: color),
              onPressed: onIconPressed,
              child: Icon(icon),
            ),
    );
  }
}
