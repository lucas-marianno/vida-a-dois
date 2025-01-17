part of 'user_settings_bloc.dart';

sealed class UserSettingsEvent extends Equatable {
  const UserSettingsEvent();

  @override
  List<Object> get props => [];
}

// public
final class LoadUserSettings extends UserSettingsEvent {
  final String uid;

  const LoadUserSettings(this.uid);

  @override
  List<Object> get props => [uid];
}

final class ChangeLocale extends UserSettingsEvent {
  final Locale locale;

  const ChangeLocale(this.locale);

  @override
  List<Object> get props => [locale];
}

final class ChangeThemeMode extends UserSettingsEvent {
  final ThemeMode themeMode;

  const ChangeThemeMode(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

final class ChangeUserName extends UserSettingsEvent {
  final String userName;

  const ChangeUserName(this.userName);

  @override
  List<Object> get props => [userName];
}

final class ChangeUserInitials extends UserSettingsEvent {
  final String initials;

  const ChangeUserInitials(this.initials);

  @override
  List<Object> get props => [initials];
}

//private
final class _ListenToSettingsChanges extends UserSettingsEvent {
  final String uid;

  const _ListenToSettingsChanges(this.uid);

  @override
  List<Object> get props => [uid];
}

final class _UserSettingsUpdated extends UserSettingsEvent {
  final UserSettings userSettings;

  const _UserSettingsUpdated(this.userSettings);

  @override
  List<Object> get props => [userSettings];
}

final class _CreateSettingsForCurrentUser extends UserSettingsEvent {}

final class _HandleUserSettingsError extends UserSettingsEvent {
  final Object error;

  const _HandleUserSettingsError(this.error);

  @override
  List<Object> get props => [error];
}
