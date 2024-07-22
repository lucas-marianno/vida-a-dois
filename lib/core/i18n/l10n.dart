import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kanban/core/util/logger/logger.dart';

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

  /// TODO: refactor [locale] getter!
  ///
  /// This is a temporary solution.
  ///
  /// Later on, after user auth is implemented,
  /// this will be a config retrieved from db.
  static Locale get locale {
    final locale = PlatformDispatcher.instance.locale;
    return Locale(locale.languageCode);

    // if (!kIsWeb) return Locale(Platform.localeName.split('_')[0]);

    // Log.warning(
    //   "Unimplemented \n\n"
    //   "'Platform.localeName' is not supported to run on web.\n\n"
    //   "default locale will be used instead:\n"
    //   "$Locale('en')",
    // );
    // return const Locale('en');
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
