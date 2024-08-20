import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';

/// [AppTitle] returns the application title with i18n and l10.
///
/// The default font is `GoogleFonts.caveat`
///
/// The default fontSize is `displayLarge.fontSize`
class AppTitle extends StatelessWidget {
  final double? fontSize;
  const AppTitle({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final size = fontSize ?? Theme.of(context).textTheme.displayLarge?.fontSize;

    return Text(
      L10n.of(context).appTitle,
      style: GoogleFonts.caveat(fontSize: size),
    );
  }
}
