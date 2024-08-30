part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

final class _ListenToConnectivityChanges extends ConnectivityEvent {}

final class _GotResponse extends ConnectivityEvent {
  final ConnectivityResult result;

  const _GotResponse(this.result);

  @override
  List<Object> get props => [result];
}
