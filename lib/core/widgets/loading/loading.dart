import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String message;
  const Loading(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    const interval = Duration(milliseconds: 400);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              AnimatedTextKit(
                pause: interval,
                repeatForever: true,
                animatedTexts: [TyperAnimatedText(' ...', speed: interval)],
              ),
            ],
          )
        ],
      ),
    );
  }
}
