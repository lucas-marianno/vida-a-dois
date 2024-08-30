import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  late StreamSubscription _connection;
  ConnectivityResult? _connectionStatus;
  ConnectivityBloc() : super(ConnectivityLoading()) {
    on<ConnectivityEvent>(_logEvents);
    on<CheckConnectivity>(_onCheckConnectivityEvent);
    on<GotResponse>(_onGotResponseEvent);
    on<_ListenToConnectivityChanges>(_onListenToConnectivityChanges);

    logger.initializing(ConnectivityBloc);
    add(CheckConnectivity());
  }

  _logEvents(ConnectivityEvent event, _) {
    logger.trace('$ConnectivityBloc $ConnectivityEvent \n $event');
  }

  _onCheckConnectivityEvent(_, Emitter<ConnectivityState> emit) async {
    emit(ConnectivityLoading());

    try {
      final connectionStatus = await Connectivity().checkConnectivity();

      if (connectionStatus[0] == _connectionStatus) {
        await Future.delayed(const Duration(seconds: 3));
      }

      add(GotResponse(connectionStatus[0]));
    } catch (e) {
      emit(ConnectivityErrorState(e));
      add(_ListenToConnectivityChanges());
    }
  }

  _onListenToConnectivityChanges(_, Emitter<ConnectivityState> emit) {
    _connection = Connectivity().onConnectivityChanged.listen(
          (response) => add(GotResponse(response[0])),
          onError: (e) => emit(ConnectivityErrorState(e)),
          cancelOnError: false,
        );
  }

  _onGotResponseEvent(
      GotResponse event, Emitter<ConnectivityState> emit) async {
    _connectionStatus = event.result;

    if (_connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.ethernet) {
      logger.info("$ConnectivityBloc $HasInternetConnection");
      emit(HasInternetConnection());
    } else if (_connectionStatus == ConnectivityResult.none) {
      logger.warning("$ConnectivityBloc $NoInternetConnection");
      emit(NoInternetConnection());
    } else {
      logger.error("$ConnectivityBloc $ConnectivityErrorState \n "
          "$_connectionStatus");
      emit(ConnectivityErrorState(_connectionStatus!));
    }
    add(_ListenToConnectivityChanges());
  }

  @override
  Future<void> close() {
    logger.trace('$ConnectivityBloc close()');
    _connection.cancel();
    return super.close();
  }
}
