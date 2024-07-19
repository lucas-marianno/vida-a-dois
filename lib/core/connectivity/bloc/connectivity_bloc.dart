import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  late StreamSubscription _connection;
  ConnectivityBloc() : super(ConnectivityLoadingState()) {
    on<CheckConnectivityEvent>(_onCheckConnectivityEvent);
    on<GotResponseEvent>(_onGotResponseEvent);
  }

  _onCheckConnectivityEvent(
    CheckConnectivityEvent event,
    Emitter<ConnectivityState> emit,
  ) async {
    emit(ConnectivityLoadingState());
    print('##################################################################');
    print('checking for internet connection');

    _connection = Connectivity().onConnectivityChanged.listen(
          (response) => add(GotResponseEvent(response)),
          onError: (e) => emit(ConnectivityErrorState(e)),
          cancelOnError: true,
        );
  }

  _onGotResponseEvent(
    GotResponseEvent event,
    Emitter<ConnectivityState> emit,
  ) async {
    final result = event.result;

    if (result[0] == ConnectivityResult.mobile ||
        result[0] == ConnectivityResult.wifi ||
        result[0] == ConnectivityResult.ethernet) {
      emit(HasInternetConnectionState());
    } else if (result[0] == ConnectivityResult.none) {
      emit(NoInternetConnectionState());
    } else {
      emit(ConnectivityErrorState(result));
    }
  }

  @override
  Future<void> close() {
    _connection.cancel();
    return super.close();
  }
}
