import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/user_settings/data/user_data.dart';
import 'package:kanban/features/user_settings/domain/entities/user_settings.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late StreamSubscription subscription;
  UserBloc() : super(UserLoading()) {
    on<LoadUserSettings>(_onLoadUserSettings);
    on<UserSettingsLoaded>(_onUserSettingsLoaded);
    on<CreateUserSettings>(_onCreateUserSettings);
    on<HandleUserSettingsError>(_onHandleUserSettingsError);
  }

  _onLoadUserSettings(LoadUserSettings event, Emitter<UserState> emit) async {
    Log.trace('$UserBloc $LoadUserSettings \n $event');
    emit(UserLoading());

    try {
      subscription = UserSettingsDataSource.read(event.uid).listen(
        (data) => add(UserSettingsLoaded(data)),
        cancelOnError: true,
        onError: (e) => add(HandleUserSettingsError(e)),
        onDone: () => Log.trace('$UserBloc Stream is done!'),
      );
    } catch (e) {
      add(HandleUserSettingsError(e));
    }
  }

  _onUserSettingsLoaded(
    UserSettingsLoaded event,
    Emitter<UserState> emit,
  ) async {
    Log.trace('$UserBloc $UserSettingsLoaded \n ${event.userSettings.toJson}');
    emit(UserLoaded(event.userSettings));
  }

  _onCreateUserSettings(CreateUserSettings event, Emitter<UserState> emit) {
    Log.trace('$UserBloc $CreateUserSettings \n $event');

    throw UnimplementedError('$CreateUserSettings is not implemented');
  }

  _onHandleUserSettingsError(
    HandleUserSettingsError event,
    Emitter<UserState> emit,
  ) async {
    Log.error('$UserBloc $HandleUserSettingsError', error: event.error);

    emit(UserError(event.error));
  }

  @override
  Future<void> close() {
    Log.trace('$UserBloc closed');
    subscription.cancel();
    return super.close();
  }
}
