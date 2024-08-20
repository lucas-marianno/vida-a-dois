import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';

class AppSlogan extends StatelessWidget {
  const AppSlogan({super.key});

  static const _speed = Duration(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return SizedBox(
      height: 25,
      child: AnimatedTextKit(
        pause: Duration.zero,
        repeatForever: true,
        animatedTexts: [
          for (String sentence in l10n.appSlogan.split('|'))
            RotateAnimatedText(sentence, duration: _speed),
        ],
      ),
    );
  }
}
