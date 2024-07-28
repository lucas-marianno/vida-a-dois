import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanban/core/auth/data/auth_data.dart';
import 'package:kanban/core/util/logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late StreamSubscription authServiceListener;
  AuthBloc() : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<_AuthLoggedIn>(_onAuthLoggedIn);
    on<_AuthLoggedOut>(_onAuthLoggedOut);
    on<_AuthException>(_onAuthException);
    on<CreateUserWithEmailAndPassword>(_onCreateUserWithEmailAndPassword);
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<_SignInWithCredential>(_onSignInWithCredential);
    on<SignOut>(_onSignOut);

    Log.initializing(AuthBloc);
    add(AuthStarted());
  }

  _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    Log.trace('$AuthBloc $AuthStarted');
    emit(AuthLoading());

    try {
      authServiceListener = AuthData.listenToChanges().listen(
        (data) {
          if (data is User) add(_AuthLoggedIn(data));
          if (data == null) add(_AuthLoggedOut());
        },
        cancelOnError: true,
        onDone: () => Log.info("$AuthBloc AuthServiceListener is DONE"),
        onError: (e) => add(_AuthException(e)),
      );
    } catch (e) {
      add(_AuthException(e as FirebaseAuthException));
    }
  }

  _onAuthLoggedIn(_AuthLoggedIn event, Emitter<AuthState> emit) {
    Log.info("$AuthBloc $_AuthLoggedIn \n $event");
    emit(AuthAuthenticated(event.user));
  }

  _onAuthLoggedOut(_AuthLoggedOut event, Emitter<AuthState> emit) {
    Log.trace("$AuthBloc $_AuthLoggedOut \n $event");
    emit(AuthUnauthenticated());
  }

  _onCreateUserWithEmailAndPassword(
    CreateUserWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    Log.trace("$AuthBloc $CreateUserWithEmailAndPassword \n $event");
    emit(AuthLoading());
    try {
      await AuthData.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );
      await AuthData.singInWithEmailAndPassword(event.email, event.password);
    } catch (e) {
      add(_AuthException(e as FirebaseAuthException));
    }
  }

  _onSignInWithEmailAndPassword(
    SignInWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    Log.trace("$AuthBloc $SignInWithEmailAndPassword \n $event");
    emit(AuthLoading());
    try {
      await AuthData.singInWithEmailAndPassword(event.email, event.password);
    } catch (e) {
      add(_AuthException(e as FirebaseAuthException));
    }
  }

  _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    Log.trace("$AuthBloc $SignInWithGoogle");
    emit(AuthLoading());
    try {
      final credential = await AuthData.getCredentialFromGoogleAuthProvider();
      add(_SignInWithCredential(credential));
    } catch (e) {
      add(_AuthException(e));
    }
  }

  _onSignInWithCredential(
    _SignInWithCredential event,
    Emitter<AuthState> emit,
  ) async {
    Log.trace("$AuthBloc $_SignInWithCredential \n $event");
    emit(AuthLoading());

    try {
      await AuthData.signInWithCredential(event.credential);
    } catch (e) {
      add(_AuthException(e));
    }
  }

  _onAuthException(_AuthException event, Emitter<AuthState> emit) {
    Log.warning("$AuthBloc $_AuthException \n $event");
    emit(AuthError(event.error));
  }

  _onSignOut(_, Emitter<AuthState> emit) async {
    Log.trace('$AuthBloc $SignOut');
    emit(AuthLoading());
    await AuthData.signout();
  }

  @override
  Future<void> close() {
    Log.trace('$AuthBloc Bloc closed');
    authServiceListener.cancel();
    return super.close();
  }
}
