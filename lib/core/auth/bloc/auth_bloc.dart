import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanban/core/auth/data/auth_service.dart';
import 'package:kanban/core/util/logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late StreamSubscription authServiceListener;
  AuthBloc() : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthFailed>(_onAuthFailed);
    on<CreateUserWithEmailAndPassword>(_onCreateUserWithEmailAndPassword);
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<SignOut>(_onSignOut);

    Log.initializing(AuthBloc);
    add(AuthStarted());
  }

  _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    Log.trace('$AuthBloc $AuthStarted');
    emit(AuthLoading());
    //TODO: Implement user authentication logic
    try {
      authServiceListener = AuthService.listenToChanges().listen(
        (data) {
          if (data is User) add(AuthLoggedIn(data));
          if (data == null) add(AuthLoggedOut());
        },
        cancelOnError: true,
        onDone: () => Log.info("$AuthBloc AuthServiceListener is DONE"),
        onError: (e) => add(AuthFailed(e)),
      );
    } catch (e) {
      add(AuthFailed(e));
    }
  }

  _onAuthLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) {
    Log.info("$AuthBloc $AuthLoggedIn \n $event");
    //TODO: Implement
    emit(AuthAuthenticated());
  }

  _onAuthLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) {
    Log.trace("$AuthBloc $AuthLoggedOut \n $event");
    //TODO: Implement
    emit(AuthUnauthenticated());
  }

  _onCreateUserWithEmailAndPassword(
    CreateUserWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await AuthService.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );
      AuthService.singInWithEmailAndPassword(event.email, event.password);
    } catch (e) {
      add(AuthFailed(e));
    }
  }

  _onSignInWithEmailAndPassword(
    SignInWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await AuthService.singInWithEmailAndPassword(event.email, event.password);
    } catch (e) {
      add(AuthFailed(e));
    }
  }

  _onAuthFailed(AuthFailed event, Emitter<AuthState> emit) {
    Log.trace("$AuthBloc $AuthFailed \n $event");
    //TODO: implement
    emit(AuthError(event.error));
  }

  _onSignOut(_, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await AuthService.signout();
  }

  @override
  Future<void> close() {
    authServiceListener.cancel();
    return super.close();
  }
}
