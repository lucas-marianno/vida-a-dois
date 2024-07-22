import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/i18n/bloc/locale_bloc.dart';
import 'package:kanban/core/theme/app_theme.dart';
import 'package:kanban/core/i18n/l10n.dart';

class VidaADoidApp extends StatelessWidget {
  const VidaADoidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        Locale? locale;
        if (state is LocaleLoaded) {
          locale = state.locale;
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          localizationsDelegates: L10n.delegates,
          locale: locale,
          theme: AppTheme.light,
          initialRoute: Routes.homePage,
          routes: Routes.routes,
        );
      },
    );
  }
}
