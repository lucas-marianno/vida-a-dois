part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class LoadUserSettings extends UserEvent {
  final String uid;

  const LoadUserSettings(this.uid);

  @override
  List<Object> get props => [uid];
}

final class UserSettingsLoaded extends UserEvent {
  final UserSettings userSettings;

  const UserSettingsLoaded(this.userSettings);

  @override
  List<Object> get props => [userSettings];
}

final class CreateUserSettings extends UserEvent {
  final User user;

  const CreateUserSettings(this.user);

  @override
  List<Object> get props => [user];
}

final class HandleUserSettingsError extends UserEvent {
  final Object error;

  const HandleUserSettingsError(this.error);

  @override
  List<Object> get props => [error];
}
