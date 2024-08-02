part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserSettingsLoading extends UserState {}

final class UserSettingsLoaded extends UserState {
  final UserSettings userSettings;

  const UserSettingsLoaded(this.userSettings);

  @override
  List<Object> get props => [userSettings];
}

final class UserSettingsError extends UserState {
  final Object error;

  const UserSettingsError(this.error);

  @override
  List<Object> get props => [error];
}
