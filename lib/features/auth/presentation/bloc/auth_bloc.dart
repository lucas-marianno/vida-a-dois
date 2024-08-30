import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vida_a_dois/features/auth/data/auth_data.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthDataSource authDataSource;
  late StreamSubscription authServiceListener;
  AuthBloc(this.authDataSource) : super(AuthInitial()) {
    on<AuthEvent>(_logEvents);
    on<AuthStarted>(_onAuthStarted);
    on<_AuthLoggedIn>(_onAuthLoggedIn);
    on<_AuthLoggedOut>(_onAuthLoggedOut);
    on<_AuthException>(_onAuthException);
    on<CreateUserWithEmailAndPassword>(_onCreateUserWithEmailAndPassword);
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<_SignInWithCredential>(_onSignInWithCredential);
    on<SignOut>(_onSignOut);

    logger.initializing(AuthBloc);
    add(AuthStarted());
  }
  _logEvents(AuthEvent event, _) {
    switch (event) {
      case _AuthException():
        logger.warning('$AuthBloc $_AuthException', error: event.error);
        break;
      default:
        logger.trace('$AuthBloc $AuthEvent \n $event');
    }
  }

  _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      authServiceListener = authDataSource.stream.listen(
        (data) {
          if (data is User) add(_AuthLoggedIn());
          if (data == null) add(_AuthLoggedOut());
        },
        cancelOnError: true,
        onDone: () => logger.info("$AuthBloc AuthListener is DONE"),
        onError: (e) => add(_AuthException(e)),
      );
    } catch (e) {
      add(_AuthException(e as FirebaseAuthException));
    }
  }

  _onAuthLoggedIn(_, Emitter<AuthState> emit) {
    final currentUser = authDataSource.authInstance.currentUser!;
    emit(AuthAuthenticated(currentUser));
  }

  _onAuthLoggedOut(_AuthLoggedOut event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }

  _onCreateUserWithEmailAndPassword(
    CreateUserWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authDataSource.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );
      await authDataSource.singInWithEmailAndPassword(
          event.email, event.password);
    } catch (e) {
      add(_AuthException(e as FirebaseAuthException));
    }
  }

  _onSignInWithEmailAndPassword(
    SignInWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authDataSource.singInWithEmailAndPassword(
          event.email, event.password);
    } catch (e) {
      add(_AuthException(e as FirebaseAuthException));
    }
  }

  _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final credential =
          await authDataSource.getCredentialFromGoogleAuthProvider();
      if (credential == null) {
        add(_AuthLoggedOut());
        return;
      }

      add(_SignInWithCredential(credential));
    } catch (e) {
      add(_AuthException(e));
    }
  }

  _onSignInWithCredential(
    _SignInWithCredential event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await authDataSource.signInWithCredential(event.credential);
    } catch (e) {
      add(_AuthException(e));
    }
  }

  _onAuthException(_AuthException event, Emitter<AuthState> emit) {
    if (event.error is FirebaseAuthException) {
      emit(AuthError(event.error as FirebaseAuthException));
    } else {
      emit(AuthError(event.error));
    }
  }

  _onSignOut(_, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authDataSource.signout();
  }

  @override
  Future<void> close() {
    logger.trace('$AuthBloc Bloc closed');
    authServiceListener.cancel();
    return super.close();
  }
}
