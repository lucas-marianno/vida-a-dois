part of 'user_bloc.dart';

sealed class UserSettingsEvent extends Equatable {
  const UserSettingsEvent();

  @override
  List<Object> get props => [];
}

final class LoadUserSettings extends UserSettingsEvent {
  final String uid;

  const LoadUserSettings(this.uid);

  @override
  List<Object> get props => [uid];
}

final class _UserSettingsUpdated extends UserSettingsEvent {
  final UserSettings userSettings;

  const _UserSettingsUpdated(this.userSettings);

  @override
  List<Object> get props => [userSettings];
}

final class CreateUserSettings extends UserSettingsEvent {
  final User user;

  const CreateUserSettings(this.user);

  @override
  List<Object> get props => [user];
}

final class ChangeLocale extends UserSettingsEvent {
  final Locale locale;

  const ChangeLocale(this.locale);

  @override
  List<Object> get props => [locale];
}

final class _HandleUserSettingsError extends UserSettingsEvent {
  final Object error;

  const _HandleUserSettingsError(this.error);

  @override
  List<Object> get props => [error];
}
