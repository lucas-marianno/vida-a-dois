import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/i18n/bloc/locale_bloc.dart';
import 'package:kanban/core/theme/app_theme.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/features/user_settings/bloc/user_bloc.dart';

class VidaADoidApp extends StatelessWidget {
  const VidaADoidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        Locale? locale;
        if (state is UserLoaded) {
          locale = state.userSettings.locale;
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          localizationsDelegates: L10n.delegates,
          locale: locale,
          themeMode: Theme,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          initialRoute: Routes.root,
          routes: Routes.routes,
        );
      },
    );
    // return BlocBuilder<LocaleBloc, LocaleState>(
    //   builder: (context, state) {
    //     Locale? locale;
    //     if (state is LocaleLoaded) {
    //       locale = state.locale;
    //     }
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       supportedLocales: L10n.all,
    //       localizationsDelegates: L10n.delegates,
    //       locale: locale,
    //       theme: AppTheme.theme,
    //       initialRoute: Routes.root,
    //       routes: Routes.routes,
    //     );
    //   },
    // );
  }
}
