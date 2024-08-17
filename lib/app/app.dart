import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/theme/app_theme.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/features/user_settings/bloc/user_settings_bloc.dart';

class VidaADoidApp extends StatelessWidget {
  const VidaADoidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSettingsBloc, UserSettingsState>(
      builder: (context, state) {
        Locale? locale;
        ThemeMode themeMode = ThemeMode.system;
        if (state is UserSettingsLoaded) {
          locale = state.userSettings.locale;
          themeMode = state.userSettings.themeMode;
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          localizationsDelegates: L10n.delegates,
          locale: locale,
          themeMode: themeMode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          initialRoute: Routes.root,
          routes: Routes.routes,
        );
      },
    );
  }
}
