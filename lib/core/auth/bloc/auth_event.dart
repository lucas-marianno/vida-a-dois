part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthStarted extends AuthEvent {}

final class AuthLoggedIn extends AuthEvent {}

final class AuthLoggedOut extends AuthEvent {}

final class AuthFailed extends AuthEvent {}
