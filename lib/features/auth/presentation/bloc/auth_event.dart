part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthStarted extends AuthEvent {}

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

final class SignOut extends AuthEvent {}

// final class _AuthException extends AuthEvent {
//   final dynamic error;

//   const _AuthException(this.error);

//   @override
//   List<Object> get props => [error];
// }
