import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/auth/bloc/auth_bloc.dart';
import 'package:kanban/core/auth/pages/login_page.dart';
import 'package:kanban/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/widgets/loading/loading.dart';
import 'features/kanban/presentation/pages/kanban_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          if (state is HasInternetConnectionState) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) return const KanbanPage();
                if (state is AuthLoading) return const Loading('Logging in');
                return const AuthPage();
              },
            );
          } else if (state is ConnectivityLoadingState) {
            return const Loading('Checking for internet connection');
          } else if (state is NoInternetConnectionState) {
            return Center(
              child: Text(L10n.of(context).warningNoInternet),
            );
          } else {
            return Center(
              child: Text(
                L10n.of(context).unexpectedInternetError(state.toString()),
              ),
            );
          }
        },
      ),
    );
  }
}
