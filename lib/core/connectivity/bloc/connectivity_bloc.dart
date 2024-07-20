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
  ConnectivityBloc() : super(ConnectivityLoadingState()) {
    on<CheckConnectivityEvent>(_onCheckConnectivityEvent);
    on<GotResponseEvent>(_onGotResponseEvent);

    Log.initializing(ConnectivityBloc);
  }

  _onCheckConnectivityEvent(
    CheckConnectivityEvent event,
    Emitter<ConnectivityState> emit,
  ) async {
    Log.trace("$ConnectivityBloc $CheckConnectivityEvent \n $event");
    emit(ConnectivityLoadingState());

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

    final result = event.result;

    if (result[0] == ConnectivityResult.mobile ||
        result[0] == ConnectivityResult.wifi ||
        result[0] == ConnectivityResult.ethernet) {
      Log.info("$ConnectivityBloc $HasInternetConnectionState");
      emit(HasInternetConnectionState());
    } else if (result[0] == ConnectivityResult.none) {
      Log.warning("$ConnectivityBloc $NoInternetConnectionState");
      emit(NoInternetConnectionState());
    } else {
      Log.error("$ConnectivityBloc $ConnectivityErrorState \n $result");
      emit(ConnectivityErrorState(result));
    }
  }

  @override
  Future<void> close() {
    Log.trace('$ConnectivityBloc close()');
    _connection.cancel();
    return super.close();
  }
}
