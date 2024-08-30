import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';
import 'package:vida_a_dois/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vida_a_dois/features/user_settings/data/user_data.dart';
import 'package:vida_a_dois/features/user_settings/domain/entities/user_settings.dart';

part 'user_settings_event.dart';
part 'user_settings_state.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  final FirebaseAuth firebaseAuth;
  late StreamSubscription subscription;
  UserSettings? currentUserSettings;

  UserSettingsBloc(this.firebaseAuth) : super(UserSettingsLoading()) {
    on<UserSettingsEvent>(_logEvents);
    on<LoadUserSettings>(_onLoadUserSettings);
    on<ChangeLocale>(_onChangeLocaleEvent);
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<ChangeUserName>(_onChangeUserName);
    on<ChangeUserInitials>(_onChangeUserInitials);
    on<_ListenToSettingsChanges>(_onListenToSettingsChanges);
    on<_UserSettingsUpdated>(_onUserSettingsLoaded);
    on<_CreateSettingsForCurrentUser>(_onCreateUserSettings);
    on<_HandleUserSettingsError>(_onHandleUserSettingsError);

    logger.initializing(UserSettingsBloc);
  }
  _logEvents(UserSettingsEvent event, _) {
    switch (event) {
      case _UserSettingsUpdated():
        logger.trace(
          '$UserSettingsBloc $_UserSettingsUpdated \n'
          ' ${event.userSettings.toJson}',
        );
        break;
      case _HandleUserSettingsError():
        logger.warning(
          '$UserSettingsBloc $_HandleUserSettingsError',
          error: event.error,
        );
        break;
      default:
        logger.trace('$UserSettingsBloc ${event.runtimeType} \n $event');
    }
  }

  _onLoadUserSettings(
    LoadUserSettings event,
    Emitter<UserSettingsState> emit,
  ) async {
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
    if (currentUserSettings!.themeMode == event.themeMode) return;

    currentUserSettings!.themeMode = event.themeMode;
    await UserSettingsDataSource.update(currentUserSettings!);
  }

  _onChangeUserName(ChangeUserName event, _) async {
    if (currentUserSettings!.userName == event.userName) return;
    currentUserSettings!.userName = event.userName;

    await UserSettingsDataSource.update(currentUserSettings!);
  }

  _onChangeUserInitials(ChangeUserInitials event, _) async {
    if (currentUserSettings?.initials == event.initials) return;
    currentUserSettings!.initials =
        event.initials.substring(0, 2).toUpperCase();

    await UserSettingsDataSource.update(currentUserSettings!);
  }

  _onListenToSettingsChanges(
    _ListenToSettingsChanges event,
    Emitter<UserSettingsState> emmit,
  ) {
    try {
      subscription = UserSettingsDataSource.read(event.uid).listen(
        (data) => add(_UserSettingsUpdated(data)),
        cancelOnError: true,
        onError: (e) => add(_HandleUserSettingsError(e)),
        onDone: () => logger.trace('$UserSettingsBloc Stream is done!'),
      );
    } catch (e) {
      add(_HandleUserSettingsError(e));
    }
  }

  _onUserSettingsLoaded(
    _UserSettingsUpdated event,
    Emitter<UserSettingsState> emit,
  ) {
    if (event.userSettings == currentUserSettings) return;
    currentUserSettings = event.userSettings;

    emit(UserSettingsLoaded(currentUserSettings!));
  }

  _onCreateUserSettings(_, __) async {
    final user = firebaseAuth.currentUser!;
    final userName = user.displayName ?? user.email!.split('@')[0];

    logger.trace('$AuthBloc: current user: $user');

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
    emit(UserSettingsError(event.error));
  }

  @override
  Future<void> close() {
    logger.trace('$UserSettingsBloc closed');
    subscription.cancel();
    return super.close();
  }
}
