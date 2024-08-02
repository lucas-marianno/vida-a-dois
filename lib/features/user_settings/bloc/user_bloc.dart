import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/user_settings/data/user_data.dart';
import 'package:kanban/features/user_settings/domain/entities/user_settings.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserState> {
  late StreamSubscription subscription;
  UserSettings? currentUserSettings;
  UserSettingsBloc() : super(UserSettingsLoading()) {
    on<LoadUserSettings>(_onLoadUserSettings);
    on<_UserSettingsUpdated>(_onUserSettingsLoaded);
    on<CreateUserSettings>(_onCreateUserSettings);
    on<ChangeLocale>(_onChangeLocaleEvent);
    on<_HandleUserSettingsError>(_onHandleUserSettingsError);
  }

  _onLoadUserSettings(LoadUserSettings event, Emitter<UserState> emit) async {
    Log.trace('$UserSettingsBloc $LoadUserSettings \n $event');
    emit(UserSettingsLoading());

    try {
      subscription = UserSettingsDataSource.read(event.uid).listen(
        (data) => add(_UserSettingsUpdated(data)),
        cancelOnError: true,
        onError: (e) => add(_HandleUserSettingsError(e)),
        onDone: () => Log.trace('$UserSettingsBloc Stream is done!'),
      );
    } catch (e) {
      Log.warning('$UserSettingsBloc $LoadUserSettings error!');
      add(_HandleUserSettingsError(e));
    }
  }

  _onUserSettingsLoaded(
    _UserSettingsUpdated event,
    Emitter<UserState> emit,
  ) async {
    Log.trace(
      '$UserSettingsBloc $_UserSettingsUpdated \n'
      ' ${event.userSettings.toJson}',
    );

    if (event.userSettings == currentUserSettings) return;
    currentUserSettings = event.userSettings;

    emit(UserSettingsLoaded(currentUserSettings!));
  }

  _onCreateUserSettings(CreateUserSettings event, Emitter<UserState> emit) {
    Log.trace('$UserSettingsBloc $CreateUserSettings \n $event');

    throw UnimplementedError('$CreateUserSettings is not implemented');
  }

  _onChangeLocaleEvent(ChangeLocale event, Emitter<UserState> emit) async {
    Log.trace("$UserSettingsBloc $ChangeLocale \n $event");
    emit(UserSettingsLoading());

    if (!L10n.all.contains(event.locale)) {
      add(_HandleUserSettingsError(
        UnimplementedError(
          "$UserSettingsBloc:\n Unimplemented locale: ${event.locale}",
        ),
      ));
      return;
    }

    currentUserSettings!.locale = event.locale;

    await UserSettingsDataSource.update(currentUserSettings!);
  }

  _onHandleUserSettingsError(
    _HandleUserSettingsError event,
    Emitter<UserState> emit,
  ) async {
    Log.error('$UserSettingsBloc $_HandleUserSettingsError',
        error: event.error);

    emit(UserSettingsError(event.error));
  }

  @override
  Future<void> close() {
    Log.trace('$UserSettingsBloc closed');
    subscription.cancel();
    return super.close();
  }
}
