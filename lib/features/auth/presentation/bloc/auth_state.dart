part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);
  @override
  List<Object> get props => [user];
}

final class AuthUnauthenticated extends AuthState {}

/// [AuthError] can throw:
///
/// `FirebaseAuthException` and unknown `Exception`
final class AuthError extends AuthState {
  final dynamic error;

  const AuthError(this.error);
  @override
  List<Object> get props => [error];
}
