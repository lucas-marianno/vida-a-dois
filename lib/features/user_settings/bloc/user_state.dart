part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final UserSettings userSettings;

  const UserLoaded(this.userSettings);

  @override
  List<Object> get props => [userSettings];
}

final class UserError extends UserState {
  final Object error;

  const UserError(this.error);

  @override
  List<Object> get props => [error];
}
