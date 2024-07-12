import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  final String title;
  final void Function() onIconPressed;
  final IconData? icon;

  const FormTitle({
    required this.title,
    required this.onIconPressed,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: icon == null
          ? null
          : ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                foregroundColor: WidgetStatePropertyAll<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              onPressed: onIconPressed,
              child: Icon(icon),
            ),
    );
  }
}
