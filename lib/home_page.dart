import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/auth/bloc/auth_bloc.dart';
import 'package:kanban/core/auth/pages/login_page.dart';
import 'package:kanban/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/error_dialog.dart';
import 'package:kanban/core/util/dialogs/info_dialog.dart';
import 'package:kanban/core/util/dialogs/loading_dialog.dart';
import 'package:kanban/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void popUntilHome(BuildContext context) {
    Navigator.popUntil(
      context,
      ModalRoute.withName(Routes.homePage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final auth = context.read<AuthBloc>();
    final connection = context.read<ConnectivityBloc>();
    return Material(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) async {
              popUntilHome(context);
              if (state is ConnectivityLoading) {
                Loading.show(context, l10n.checkingInternetConnection);
              } else if (state is NoInternetConnection) {
                await InfoDialog.show(context, l10n.warningNoInternet);
                connection.add(CheckConnectivityEvent());
              } else if (state is ConnectivityErrorState) {
                await ErrorDialog.show(context, state.error);
                connection.add(CheckConnectivityEvent());
              } else {
                popUntilHome(context);
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              popUntilHome(context);
              if (state is AuthLoading) {
                Loading.show(context, l10n.authenticating);
              } else if (state is AuthError &&
                  state.authError.code == 'invalid-credential') {
                await InfoDialog.show(context, l10n.authError);
                auth.add(AuthStarted());
              } else if (state is AuthAuthenticated) {
                Navigator.pushReplacementNamed(context, Routes.home);
              } else {
                popUntilHome(context);
              }
            },
          ),
        ],
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, state) {
            if (state is HasInternetConnection) {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) return const Home();
                  return const AuthPage();
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
