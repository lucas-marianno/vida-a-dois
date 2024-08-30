part of 'connectivity_bloc.dart';

sealed class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

final class ConnectivityLoading extends ConnectivityState {}

final class HasInternetConnection extends ConnectivityState {}

final class NoInternetConnection extends ConnectivityState {}

final class ConnectivityError extends ConnectivityState {
  final Object error;

  const ConnectivityError(this.error);

  @override
  List<Object> get props => [error];
}
