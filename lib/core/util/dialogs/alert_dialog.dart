import 'package:flutter/material.dart';
import 'package:kanban/core/i18n/l10n.dart';

class ConfirmationDialog extends StatelessWidget {
  final BuildContext context;
  final String? title;
  final String content;
  final void Function() onAccept;
  final void Function()? onCancel;

  const ConfirmationDialog({
    required this.context,
    this.title,
    required this.content,
    required this.onAccept,
    this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title == null ? null : SelectableText(title!),
      content: SelectableText(content),
      actions: [
        onCancel == null
            ? const SizedBox()
            : ElevatedButton(
                onPressed: onCancel,
                child: Text(L10n.of(context).cancel),
              ),
        FilledButton(
          onPressed: onAccept,
          child: Text(L10n.of(context).ok),
        )
      ],
    );
  }
}
