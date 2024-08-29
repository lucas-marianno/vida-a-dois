import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:vida_a_dois/core/util/logger/logger.dart';
import 'package:vida_a_dois/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:vida_a_dois/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'package:vida_a_dois/features/user_settings/bloc/user_settings_bloc.dart';
import 'package:vida_a_dois/injection_container.dart';

void main() async {
  Log.initializing('main');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setUpLocator(FirebaseFirestore.instance);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityBloc>(create: (_) => ConnectivityBloc()),
        BlocProvider<UserSettingsBloc>(create: (_) => UserSettingsBloc()),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<BoardBloc>(create: (_) => locator<BoardBloc>()),
        BlocProvider<TaskBloc>(create: (_) => locator<TaskBloc>()),
      ],
      child: const VidaADoidApp(),
    ),
  );
}
