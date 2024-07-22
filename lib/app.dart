import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/i18n/bloc/locale_bloc.dart';
import 'package:kanban/core/theme/app_theme.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/core/i18n/l10n.dart';

class VidaADoidApp extends StatefulWidget {
  const VidaADoidApp({super.key});

  @override
  State<VidaADoidApp> createState() => _VidaADoidAppState();
}

class _VidaADoidAppState extends State<VidaADoidApp> {
  Locale? locale;
  late final LocaleBloc localeBloc;
  late final StreamSubscription<LocaleState> localeListener;

  void initListeners() {
    Log.initializing('initListeners');

    localeListener = localeBloc.stream.listen((state) {
      if (state is LocaleLoaded) {
        setState(() => locale = state.locale);
      }
    });
  }

  @override
  void dispose() {
    localeListener.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    localeBloc = context.read<LocaleBloc>()..add(Initialize(context));

    initListeners();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      localizationsDelegates: L10n.delegates,
      locale: locale,
      theme: AppTheme.light,
      initialRoute: Routes.homePage,
      routes: Routes.routes,
    );
  }
}
