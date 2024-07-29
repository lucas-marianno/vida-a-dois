import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

/// An [AlertDialog] widget that displays a [CircularProgressIndicator]
/// and an Animated Message.
///
/// You can use it by itself, or you can call [show] to display it
/// above the current route.
class Loading extends StatelessWidget {
  final String message;
  const Loading(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    const interval = Duration(milliseconds: 400);

    return AlertDialog(
      title: const Center(child: CircularProgressIndicator()),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          AnimatedTextKit(
            pause: interval,
            repeatForever: true,
            animatedTexts: [TyperAnimatedText(' ...', speed: interval)],
          ),
        ],
      ),
    );
  }

  /// Shows a [Loading] widget above the current route.
  ///
  /// It cannot autodismiss itself, therefore you must use [Navigator.popUntil]
  /// and specify the desired route when [Loading] is not wanted anymore.
  ///
  /// Example:
  /// ```dart
  /// if (condition) {
  ///   Loading.show(context, 'Loading Message');
  /// } else {
  ///   Navigator.popUntil(
  ///     context,
  ///     ModalRoute.withName('/currentPageName'),
  ///   );
  /// }
  /// ```
  static Future<void> show(BuildContext context, String message) async {
    await showDialog(context: context, builder: (context) => Loading(message));
  }
}
