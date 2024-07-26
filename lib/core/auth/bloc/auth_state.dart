part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  //TODO: implement AuthAuthenticated
}

final class AuthUnauthenticated extends AuthState {}

final class AuthError extends AuthState {
  final Object error;

  const AuthError(this.error);
  @override
  List<Object> get props => [error];
}
