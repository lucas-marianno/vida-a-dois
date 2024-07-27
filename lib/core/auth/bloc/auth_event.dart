part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthStarted extends AuthEvent {}

final class AuthLoggedIn extends AuthEvent {
  final User user;

  const AuthLoggedIn(this.user);
  @override
  List<Object> get props => [user];
}

final class AuthLoggedOut extends AuthEvent {}

final class AuthFailed extends AuthEvent {
  final FirebaseAuthException error;

  const AuthFailed(this.error);

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

final class SignOut extends AuthEvent {}
