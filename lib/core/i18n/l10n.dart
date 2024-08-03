import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class L10n {
  static const all = [
    Locale('en'),
    Locale('pt'),
  ];

  static const delegates = [
    AppLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate
  ];

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context)!;

  static Locale get currentDeviceLocale {
    final locale = PlatformDispatcher.instance.locale;
    return Locale(locale.languageCode);
  }

  static String getflag(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    switch (code) {
      case 'en':
        return '🇺🇸';
      case 'pt':
        return '🇧🇷';
      default:
        throw UnimplementedError('Uninplemented locale: $code');
    }
  }
}
