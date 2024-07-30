import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/app.dart';
import 'package:kanban/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kanban/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:kanban/core/i18n/bloc/locale_bloc.dart';
import 'package:kanban/core/util/logger/logger.dart';
import 'package:kanban/features/kanban/presentation/bloc/board/board_bloc.dart';
import 'package:kanban/features/kanban/presentation/bloc/task/task_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Log.initializing('main');
  Log.initializing('$MultiBlocProvider');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityBloc>(create: (_) => ConnectivityBloc()),
        BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<BoardBloc>(create: (_) => BoardBloc()),
        BlocProvider<TaskBloc>(create: (_) => TaskBloc()),
      ],
      child: const VidaADoidApp(),
    ),
  );
}
