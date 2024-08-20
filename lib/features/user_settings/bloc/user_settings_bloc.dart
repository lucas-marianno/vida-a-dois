import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';
import 'package:vida_a_dois/features/auth/data/auth_data.dart';
import 'package:vida_a_dois/features/user_settings/data/user_data.dart';
import 'package:vida_a_dois/features/user_settings/domain/entities/user_settings.dart';

part 'user_settings_event.dart';
part 'user_settings_state.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  late StreamSubscription subscription;
  UserSettings? currentUserSettings;
  UserSettingsBloc() : super(UserSettingsLoading()) {
    on<LoadUserSettings>(_onLoadUserSettings);
    on<ChangeLocale>(_onChangeLocaleEvent);
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<ChangeUserName>(_onChangeUserName);
    on<ChangeUserInitials>(_onChangeUserInitials);
    on<_ListenToSettingsChanges>(_onListenToSettingsChanges);
    on<_UserSettingsUpdated>(_onUserSettingsLoaded);
    on<_CreateSettingsForCurrentUser>(_onCreateUserSettings);
    on<_HandleUserSettingsError>(_onHandleUserSettingsError);

    Log.initializing(UserSettingsBloc);
  }

  _onLoadUserSettings(
    LoadUserSettings event,
    Emitter<UserSettingsState> emit,
  ) async {
    Log.trace('$UserSettingsBloc $LoadUserSettings \n $event');
    emit(UserSettingsLoading());

    //check if user has settings configured
    final userSettings = await UserSettingsDataSource.getSettings(event.uid);
    if (userSettings == null) {
      add(_CreateSettingsForCurrentUser());
      return;
    }
    add(_ListenToSettingsChanges(event.uid));
  }

  _onChangeLocaleEvent(ChangeLocale event, __) async {
    Log.trace("$UserSettingsBloc $ChangeLocale \n $event");

    if (!L10n.all.contains(event.locale)) {
      add(_HandleUserSettingsError(
        UnimplementedError(
          "$UserSettingsBloc:\n Unimplemented locale: ${event.locale}",
        ),
      ));
      return;
    }

    if (currentUserSettings!.locale == event.locale) return;
    currentUserSettings!.locale = event.locale;

    await UserSettingsDataSource.update(currentUserSettings!);
  }

  _onChangeThemeMode(ChangeThemeMode event, __) async {
    Log.trace('$UserSettingsBloc $ChangeThemeMode \n $event');

    if (currentUserSettings!.themeMode == event.themeMode) return;

    currentUserSettings!.themeMode = event.themeMode;
    await UserSettingsDataSource.update(currentUserSettings!);
  }

  _onChangeUserName(ChangeUserName event, _) async {
    Log.trace('$UserSettingsBloc $ChangeUserName \n $event');

    if (currentUserSettings!.userName == event.userName) return;
    currentUserSettings!.userName = event.userName;

    await UserSettingsDataSource.update(currentUserSettings!);
  }

  _onChangeUserInitials(ChangeUserInitials event, _) async {
    Log.trace('$UserSettingsBloc $ChangeUserInitials \n $event');

    if (currentUserSettings?.initials == event.initials) return;
    currentUserSettings!.initials =
        event.initials.substring(0, 2).toUpperCase();

    await UserSettingsDataSource.update(currentUserSettings!);
  }

  _onListenToSettingsChanges(
    _ListenToSettingsChanges event,
    Emitter<UserSettingsState> emmit,
  ) {
    Log.trace('$UserSettingsBloc $_ListenToSettingsChanges');

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
    Emitter<UserSettingsState> emit,
  ) {
    Log.trace(
      '$UserSettingsBloc $_UserSettingsUpdated \n'
      ' ${event.userSettings.toJson}',
    );

    if (event.userSettings == currentUserSettings) return;
    currentUserSettings = event.userSettings;

    emit(UserSettingsLoaded(currentUserSettings!));
  }

  _onCreateUserSettings(_, __) async {
    final user = AuthData.currentUser!;
    final userName = user.displayName ?? user.email!.split('@')[0];

    Log.trace(
      '$UserSettingsBloc $_CreateSettingsForCurrentUser\n'
      'current user: $user',
    );

    late final String initials;
    if (userName.isEmpty) {
      initials = user.email!.substring(0, 2);
    } else {
      initials = userName
          .splitMapJoin(' ', onMatch: (_) => '', onNonMatch: (m) => m[0])
          .substring(0, 2);
    }

    await UserSettingsDataSource.create(UserSettings(
      uid: user.uid,
      userName: userName,
      themeMode: ThemeMode.system,
      locale: L10n.currentDeviceLocale,
      initials: initials,
    ));

    add(_ListenToSettingsChanges(user.uid));
  }

  _onHandleUserSettingsError(
    _HandleUserSettingsError event,
    Emitter<UserSettingsState> emit,
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
