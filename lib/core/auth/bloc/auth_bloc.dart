import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kanban/core/util/logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthFailed>(_onAuthFailed);

    Log.initializing(AuthBloc);
    add(AuthStarted());
  }

  _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    Log.trace('$AuthBloc $AuthStarted');

    emit(AuthLoading());
    //TODO: Implement user authentication logic

    await Future.delayed(const Duration(seconds: 1));

    add(AuthFailed());
  }

  _onAuthLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) {
    Log.trace("$AuthBloc $AuthLoggedIn \n $event");
    //TODO: Implement
    emit(AuthAuthenticated());
  }

  _onAuthLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) {
    Log.trace("$AuthBloc $AuthLoggedOut \n $event");
    //TODO: Implement
    emit(AuthUnauthenticated());
  }

  _onAuthFailed(AuthFailed event, Emitter<AuthState> emit) {
    Log.trace("$AuthBloc $AuthFailed \n $event");
    //TODO: implement
    emit(AuthUnauthenticated());
  }
}
