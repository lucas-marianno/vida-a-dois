import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/auth/bloc/auth_bloc.dart';
import 'package:kanban/core/auth/pages/login_page.dart';
import 'package:kanban/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/alert_dialog.dart';
import 'package:kanban/core/widgets/loading/loading.dart';
import 'features/kanban/presentation/pages/kanban_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void show(BuildContext context, ConfirmationDialog dialog) {
    showDialog(context: context, builder: (context) => dialog);
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
            listener: (context, state) {
              if (state is ConnectivityLoading) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      Loading(l10n.checkingInternetConnection),
                );
              } else if (state is NoInternetConnection) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: ConfirmationDialog(
                        context: context,
                        content: l10n.warningNoInternet,
                        onAccept: () {
                          connection.add(CheckConnectivityEvent());
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              } else if (state is ConnectivityErrorState) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: ConfirmationDialog(
                        context: context,
                        title: l10n.somethingBadHappened,
                        content: l10n.unexpectedInternetError(state.toString()),
                        onAccept: () =>
                            connection.add(CheckConnectivityEvent()),
                      ),
                    );
                  },
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthLoading) {
                //TODO: finish implementing popups
                Navigator.of(context).push(DialogRoute(
                  context: context,
                  builder: (context) {
                    return Loading(l10n.authenticating);
                  },
                ));

                // showDialog(
                //   context: context,
                //   builder: (context) => Loading(l10n.authenticating),
                // );
              } else if (state is AuthError) {
                if (state.authError.code == 'invalid-credential') {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                      context: context,
                      content: l10n.authError,
                      onAccept: () {
                        auth.add(AuthStarted());
                        Navigator.pop(context);
                      },
                    ),
                  );
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, state) {
            print('Connectivity state: $state');
            if (state is HasInternetConnection) {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  print('Auth state: $state');
                  if (state is AuthAuthenticated) return const KanbanPage();
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
