import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/core/util/logger/logger.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

final class ConnectivityBloc
    extends Bloc<ConnectivityEvent, ConnectivityState> {
  late StreamSubscription _connection;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  ConnectivityBloc() : super(ConnectivityLoading()) {
    on<CheckConnectivityEvent>(_onCheckConnectivityEvent);
    on<GotResponseEvent>(_onGotResponseEvent);
    on<ListenToConnectivityChanges>(_onListenToConnectivityChanges);

    Log.initializing(ConnectivityBloc);
    add(CheckConnectivityEvent());
  }

  _onCheckConnectivityEvent(
    _,
    Emitter<ConnectivityState> emit,
  ) async {
    Log.trace("$ConnectivityBloc $CheckConnectivityEvent");
    emit(ConnectivityLoading());

    try {
      final connectionStatus = await Connectivity().checkConnectivity();
      add(GotResponseEvent(connectionStatus));
    } catch (e) {
      emit(ConnectivityErrorState(e));
      add(ListenToConnectivityChanges());
    }
  }

  _onListenToConnectivityChanges(_, Emitter<ConnectivityState> emit) {
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
    Log.trace("$ConnectivityBloc $GotResponseEvent \n $event");

    if (event.result[0] == _connectionStatus) return;
    _connectionStatus = event.result[0];

    if (_connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.ethernet) {
      Log.info("$ConnectivityBloc $HasInternetConnection");
      emit(HasInternetConnection());
    } else if (_connectionStatus == ConnectivityResult.none) {
      Log.warning("$ConnectivityBloc $NoInternetConnection");
      emit(NoInternetConnection());
    } else {
      Log.error("$ConnectivityBloc $ConnectivityErrorState \n "
          "$_connectionStatus");
      emit(ConnectivityErrorState(_connectionStatus));
    }
    add(ListenToConnectivityChanges());
  }

  @override
  Future<void> close() {
    Log.trace('$ConnectivityBloc close()');
    _connection.cancel();
    return super.close();
  }
}
