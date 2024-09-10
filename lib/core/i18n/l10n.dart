import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Provides easy access to generated `AppLocalizations`.
///
/// `App Localizations` are generated from `.arb` files.
///
/// To update translations:
///
/// 1. update the `.arb` files accordingly;
/// 2. run `flutter gen-l10n`;
/// 3. hot-restart the flutter application.
///
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

  /// [laguageCode] must be contained in [all]
  ///
  /// [from] should preferably be used only for debug or testing.
  ///
  /// For UI usage, prefer the method [of] since it will provide current device
  /// locale sensitive `AppLocalizations`
  static Future<AppLocalizations> from(String laguageCode) async {
    assert(all.map((l) => l.languageCode).contains(laguageCode));
    return await AppLocalizations.delegate.load(Locale(laguageCode));
  }
}
