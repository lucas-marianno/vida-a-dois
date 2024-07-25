import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/i18n/bloc/locale_bloc.dart';
import 'package:kanban/core/theme/app_theme.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/features/auth/bloc/auth_bloc.dart';
import 'package:kanban/loading_page.dart';

class VidaADoidApp extends StatefulWidget {
  const VidaADoidApp({super.key});

  @override
  State<VidaADoidApp> createState() => _VidaADoidAppState();
}

class _VidaADoidAppState extends State<VidaADoidApp> {
  Locale? locale;
  bool isConnected = false;
  bool isAuthenticated = true;

  @override
  Widget build(BuildContext context) {
    bool isLoaded = locale != null && isConnected && isAuthenticated;

    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return BlocBuilder<LocaleBloc, LocaleState>(
              builder: (context, state) {
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
          },
        );
      },
    );

    //   MultiBlocListener(
    //     listeners: [
    //       BlocListener<LocaleBloc, LocaleState>(
    //         listener: (context, state) {
    //           if (state is LocaleLoading) {
    //             //   Navigator.push(
    //             //     context,
    //             //     MaterialPageRoute(
    //             //       builder: (context) => const LoadingPage(),
    //             //     ),
    //             //   );
    //           }
    //           if (state is LocaleLoaded) {
    //             setState(() => locale = state.locale);
    //           } else {
    //             setState(() => locale = null);
    //           }
    //         },
    //       ),
    //       BlocListener<ConnectivityBloc, ConnectivityState>(
    //         listener: (context, state) {
    //           if (state is HasInternetConnectionState) {
    //             setState(() => isConnected = true);
    //           } else {
    //             setState(() => isConnected = false);
    //           }
    //         },
    //       ),
    //       BlocListener<AuthBloc, AuthState>(
    //         listener: (context, state) {
    //           // TODO: implement listener
    //         },
    //       ),
    //     ],
    //     child:

    //      MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       supportedLocales: L10n.all,
    //       localizationsDelegates: L10n.delegates,
    //       locale: locale,
    //       theme: AppTheme.light,
    //       initialRoute: Routes.homePage,
    //       routes: Routes.routes,
    //     ),
    //   );
    // }

    // Widget get placeHolder {
    //   return const MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: Scaffold(
    //       body: Center(
    //         child: CircularProgressIndicator(),
    //       ),
    //     ),
    //   );
    // }
  }
}
