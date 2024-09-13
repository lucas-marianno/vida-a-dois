import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:vida_a_dois/core/util/logger.dart';

export 'package:connectivity_plus/connectivity_plus.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity connectivity;
  late StreamSubscription _streamSubscription;

  ConnectivityBloc(this.connectivity) : super(ConnectivityLoading()) {
    on<_ListenToConnectivityChanges>(_onListenToConnectivityChanges);
    on<_GotResponse>(_onGotResponse);

    logger.initializing(ConnectivityBloc);
    add(_ListenToConnectivityChanges());
  }

  _onListenToConnectivityChanges(_, Emitter<ConnectivityState> emit) {
    emit(ConnectivityLoading());
    _streamSubscription = connectivity.onConnectivityChanged.listen(
      (result) => add(_GotResponse(result.first)),
      onError: (e) => emit(ConnectivityError(e)),
    );
  }

  _onGotResponse(_GotResponse event, Emitter<ConnectivityState> emit) {
    if (event.result == ConnectivityResult.none) {
      emit(NoInternetConnection());
    } else {
      emit(HasInternetConnection());
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    logger.error(
      '$ConnectivityBloc: ${error.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(error, stackTrace);
  }

  @override
  void onChange(Change<ConnectivityState> change) {
    final message = '$ConnectivityBloc: ${change.nextState.runtimeType}';
    if (change.nextState is ConnectivityError) {
      logger.warning(message);
    } else {
      logger.debug(message);
    }
    super.onChange(change);
  }

  @override
  void onEvent(ConnectivityEvent event) {
    logger.trace('$ConnectivityBloc: ${event.runtimeType} \n $event');
    super.onEvent(event);
  }

  @override
  Future<void> close() {
    logger.trace('$ConnectivityBloc close()');
    _streamSubscription.cancel();
    return super.close();
  }
}
