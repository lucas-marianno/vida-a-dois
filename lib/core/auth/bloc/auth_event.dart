part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthStarted extends AuthEvent {}

final class _AuthLoggedIn extends AuthEvent {
  final User user;

  const _AuthLoggedIn(this.user);
  @override
  List<Object> get props => [user];
}

final class _AuthLoggedOut extends AuthEvent {}

final class _AuthException extends AuthEvent {
  final dynamic error;

  const _AuthException(this.error);

  @override
  List<Object> get props => [error];
}

final class CreateUserWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  const CreateUserWithEmailAndPassword(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

final class SignInWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailAndPassword(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

final class SignInWithGoogle extends AuthEvent {}

final class _SignInWithCredential extends AuthEvent {
  final AuthCredential credential;

  const _SignInWithCredential(this.credential);
  @override
  List<Object> get props => [credential];
}

final class SignOut extends AuthEvent {}
