import 'package:flutter/material.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/alert_dialog.dart';

class ErrorDialog extends StatelessWidget {
  final Object error;
  final void Function() onAccept;
  final void Function()? onCancel;
  const ErrorDialog(
    this.error, {
    required this.onAccept,
    this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      context: context,
      title: L10n.of(context).somethingBadHappened,
      content: L10n.of(context).unexpectedError('$error'),
      onAccept: onAccept,
      onCancel: onCancel,
    );
  }
}
