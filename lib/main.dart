import 'package:flutter/widgets.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/injection_container.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';
import 'package:vida_a_dois/core/connectivity/bloc/connectivity_bloc.dart';

import 'package:vida_a_dois/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vida_a_dois/features/user_settings/presentation/bloc/user_settings_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/board/board_bloc.dart';

// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

const kUseMocks = false;

void main() async {
  initLogger(Log(level: Level.all));
  logger.initializing('main');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kUseMocks) {
    final fakeFirestore = FakeFirebaseFirestore();
    final realConnectivity = Connectivity();
    final fakeAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(
        uid: 'uid123',
        email: 'mockUser@mail.com',
        displayName: 'mock user',
      ),
    );

    setUpLocator(fakeFirestore, fakeAuth, realConnectivity);
  } else {
    setUpLocator(
      FirebaseFirestore.instance,
      FirebaseAuth.instance,
      Connectivity(),
    );
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityBloc>(
          create: (_) => locator<ConnectivityBloc>(),
        ),
        BlocProvider<UserSettingsBloc>(
          create: (_) => locator<UserSettingsBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => locator<AuthBloc>(),
        ),
        BlocProvider<BoardBloc>(
          create: (_) => locator<BoardBloc>(),
        ),
        BlocProvider<TaskBloc>(
          create: (_) => locator<TaskBloc>(),
        ),
      ],
      child: const VidaADoidApp(),
    ),
  );
}
