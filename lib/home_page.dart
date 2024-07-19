import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/connectivity/bloc/connectivity_bloc.dart';
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
            return const Center(
              child: Text("Não há conexão com a internet!\n "
                  "\n No momento, Vida A Dois precisa de uma conexão com a internet para funcionar. \n"
                  "\n No futuro, é possível que uma versão OffLine será disponibilizada. \n"
                  "\n"
                  "\n Por gentileza, verifique se o seu aparelho possui conexão com a internet, "
                  "ou se o acesso deste aplicativo a internet está autorizado. \n"
                  "\n Tente novamente mais tarde."),
            );
          } else {
            return Center(
              child: Text("Algo de errado aconteceu\n"
                  "\n Um erro inesperado aconteceu ao tentar conectar a internet \n"
                  "\n$state\n"),
            );
          }
        },
      ),
    );
  }
}
