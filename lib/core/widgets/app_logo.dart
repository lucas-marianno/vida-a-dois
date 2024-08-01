import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban/core/i18n/l10n.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      L10n.of(context).appTitle,
      style: GoogleFonts.caveat(
        fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
      ),
    );
  }
}
