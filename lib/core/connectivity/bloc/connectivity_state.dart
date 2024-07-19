part of 'connectivity_bloc.dart';

sealed class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

final class ConnectivityLoadingState extends ConnectivityState {}

final class HasInternetConnectionState extends ConnectivityState {}

final class NoInternetConnectionState extends ConnectivityState {}

final class ConnectivityErrorState extends ConnectivityState {
  final Object error;

  const ConnectivityErrorState(this.error);

  @override
  List<Object> get props => [error];
}
