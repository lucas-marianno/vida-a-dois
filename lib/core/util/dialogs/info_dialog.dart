import 'package:flutter/material.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';

/// [InfoDialog] is an [AlertDialog] widget with pre-built style and buttons to reduce
/// boiler-plate code.
///
/// You can use it by itself, or you can call [show] to display it
/// above the current route.
class InfoDialog extends StatelessWidget {
  final String? title;
  final String content;
  final void Function()? onAccept;
  final void Function()? onCancel;

  const InfoDialog(
    this.content, {
    this.title,
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
        onAccept == null
            ? const SizedBox()
            : FilledButton(
                onPressed: onAccept,
                child: Text(L10n.of(context).ok),
              )
      ],
    );
  }

  /// Shows a [InfoDialog] widget above the current route.
  ///
  /// It will pop itself with user interaction and
  /// return `true`, `false` or `void`.
  ///
  /// Example:
  /// ```dart
  /// void example() async {
  ///   final result = await InfoDialog.show(context, 'Content');
  ///
  ///   if (result != true) return;
  ///
  ///   doStuff();
  /// }
  ///
  /// ```
  static Future<bool?> show(
    BuildContext context,
    String content, {
    String? title,
    bool showCancel = false,
    bool barrierDismissible = true,
  }) async =>
      await showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => InfoDialog(
          key: const Key('info_dialog'),
          content,
          title: title,
          onAccept:
              barrierDismissible ? () => Navigator.pop(context, true) : null,
          onCancel: showCancel ? () => Navigator.pop(context, false) : null,
        ),
      );
}
