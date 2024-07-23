import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'features/kanban/presentation/pages/kanban_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          if (state is ConnectivityLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HasInternetConnectionState) {
            return const KanbanPage();
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
