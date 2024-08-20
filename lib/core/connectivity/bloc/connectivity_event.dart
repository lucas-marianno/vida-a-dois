part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

final class CheckConnectivityEvent extends ConnectivityEvent {}

final class GotResponseEvent extends ConnectivityEvent {
  final ConnectivityResult result;

  const GotResponseEvent(this.result);

  @override
  List<Object> get props => [result];
}

final class ListenToConnectivityChanges extends ConnectivityEvent {}
