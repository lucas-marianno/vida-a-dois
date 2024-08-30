part of 'user_settings_bloc.dart';

sealed class UserSettingsState extends Equatable {
  const UserSettingsState();

  @override
  List<Object> get props => [];
}

final class UserSettingsLoading extends UserSettingsState {}

final class UserSettingsLoaded extends UserSettingsState {
  final UserSettings userSettings;

  const UserSettingsLoaded(this.userSettings);

  @override
  List<Object> get props => [userSettings];
}

final class UserSettingsError extends UserSettingsState {
  final Object error;

  const UserSettingsError(this.error);

  @override
  List<Object> get props => [error];
}
