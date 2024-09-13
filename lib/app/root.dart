import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vida_a_dois/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vida_a_dois/features/auth/presentation/pages/auth_page.dart';
import 'package:vida_a_dois/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:vida_a_dois/core/constants/routes.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/core/widgets/dialogs/error_dialog.dart';
import 'package:vida_a_dois/core/widgets/dialogs/info_dialog.dart';
import 'package:vida_a_dois/core/widgets/dialogs/loading_dialog.dart';
import 'package:vida_a_dois/features/user_settings/presentation/bloc/user_settings_bloc.dart';
import 'package:vida_a_dois/app/pages/home_page.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  void popUntilRoot(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(Routes.root));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final auth = context.read<AuthBloc>();
    final userSettings = context.read<UserSettingsBloc>();
    return Material(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) async {
              popUntilRoot(context);
              switch (state) {
                case ConnectivityLoading():
                  Loading.show(context, l10n.checkingInternetConnection);
                  break;
                case NoInternetConnection():
                  await InfoDialog.show(context, l10n.warningNoInternet);
                  break;
                case ConnectivityError():
                  await ErrorDialog.show(context, state.error);
                  break;
                default:
                  popUntilRoot(context);
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              popUntilRoot(context);
              switch (state) {
                case AuthLoading():
                  Loading.show(context, l10n.authenticating);
                  break;
                case AuthError():
                  if (state.error is FirebaseAuthException &&
                      state.error.code == 'invalid-credential') {
                    await InfoDialog.show(context, l10n.authError);
                    auth.add(AuthStarted());
                  } else {
                    await ErrorDialog.show(context, state.error);
                  }
                  break;
                case AuthAuthenticated():
                  userSettings.add(LoadUserSettings(state.user.uid));
                default:
                  popUntilRoot(context);
              }
            },
          ),
        ],
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, state) {
            if (state is HasInternetConnection) {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) return const HomePage();
                  return const AuthPage();
                },
              );
            }
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const LinearProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(l10n.checkingInternetConnection),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
