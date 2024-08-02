import 'package:flutter/material.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/info_dialog.dart';

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
    return InfoDialog(
      L10n.of(context).unexpectedError('$error'),
      title: L10n.of(context).somethingBadHappened,
      onAccept: onAccept,
      onCancel: onCancel,
    );
  }

  /// Shows an [ErrorDialog] widget above the current route.
  ///
  /// It will pop itself with user interaction and
  /// return `true`, `false` or `void`.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   doStuff();
  /// } catch (e) {
  ///   final userResponse = await ErrorDialog.show(context, e);
  ///   if (userResponse == true) {
  ///     doThis();
  ///   } else {
  ///     doThat():
  ///   }
  /// }
  /// ```
  static Future<bool?> show(BuildContext context, Object error) async {
    return await showDialog(
      context: context,
      builder: (context) => InfoDialog(
        L10n.of(context).unexpectedError('$error'),
        title: L10n.of(context).somethingBadHappened,
        onAccept: () => Navigator.pop(context, true),
      ),
    );
  }
}
