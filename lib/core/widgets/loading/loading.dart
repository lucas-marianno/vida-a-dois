import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

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
}
