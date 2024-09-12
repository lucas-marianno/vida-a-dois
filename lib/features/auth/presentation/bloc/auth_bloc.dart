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
    on<AuthStarted>(_onAuthStarted);
    on<CreateUserWithEmailAndPassword>(_onCreateUserWithEmailAndPassword);
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOut>(_onSignOut);
    on<_GotAuthResponse>(_onGotAuthResponse);

    logger.initializing(AuthBloc);
    add(AuthStarted());
  }

  _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final currentUser = authDataSource.authInstance.currentUser;
    if (currentUser != null) emit(AuthAuthenticated(currentUser));

    authServiceListener = authDataSource.stream.listen(
      (data) => add(_GotAuthResponse(data)),
      cancelOnError: false,
      onError: (e) => emit(AuthError(e)),
    );
  }

  _onGotAuthResponse(_GotAuthResponse event, Emitter<AuthState> emit) {
    if (event.data is User) emit(AuthAuthenticated(event.data!));
    if (event.data == null) emit(AuthUnauthenticated());
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
      emit(AuthError(e));
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
      emit(AuthError(e));
    }
  }

  _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    OAuthCredential? credential;
    try {
      credential = await authDataSource.getCredentialFromGoogleAuthProvider();
    } catch (e) {
      emit(AuthError(e));
    }

    if (credential == null) {
      emit(AuthUnauthenticated());
      return;
    }

    try {
      await authDataSource.signInWithCredential(credential);
    } catch (e) {
      emit(AuthError(e));
    }
  }

  _onSignOut(_, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authDataSource.signout();
  }

  @override
  void onChange(Change<AuthState> change) {
    logger.debug('$AuthBloc ${change.nextState.runtimeType}\n'
        '${change.nextState.props}');
    super.onChange(change);
  }

  @override
  void onEvent(AuthEvent event) {
    logger.trace('$AuthBloc ${event.runtimeType} \n $event');
    super.onEvent(event);
  }

  @override
  Future<void> close() {
    logger.trace('$AuthBloc Bloc closed');
    authServiceListener.cancel();
    return super.close();
  }
}
