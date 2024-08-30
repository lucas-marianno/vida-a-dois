part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

final class CheckConnectivity extends ConnectivityEvent {}

final class GotResponse extends ConnectivityEvent {
  final ConnectivityResult result;

  const GotResponse(this.result);

  @override
  List<Object> get props => [result];
}

final class _ListenToConnectivityChanges extends ConnectivityEvent {}
