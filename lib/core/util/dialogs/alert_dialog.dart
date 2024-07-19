import 'package:flutter/material.dart';

class Dialogs {
  final BuildContext context;
  Dialogs(this.context);

  Future<bool?> alertDialog({
    String? title,
    String? content,
    String? confirmButtonLabel,
    String? cancelButtonLabel,
  }) async =>
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title == null ? null : Text(title),
            content: content == null ? null : Text(content),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child:
                    cancelButtonLabel == null ? null : Text(cancelButtonLabel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: confirmButtonLabel == null
                    ? null
                    : Text(confirmButtonLabel),
              ),
            ],
          );
        },
      );
}
