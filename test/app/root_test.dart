import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:vida_a_dois/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vida_a_dois/features/auth/presentation/pages/auth_page.dart';
import 'package:vida_a_dois/features/user_settings/bloc/user_settings_bloc.dart';

import '../helper/mock_blocs.dart';

void main() async {
  late Widget myApp;
  final multiBloc = MultiMockBloc();
  myApp = multiBloc.provideWithBlocs(const VidaADoidApp());

  setUp(() {
    when(() => multiBloc.userSettings.state).thenReturn(UserSettingsLoading());

    when(() => multiBloc.auth.state).thenReturn(AuthLoading());
  });

  testWidgets(
      'should find one empty SizedBox \n'
      'when launching app Without internet', (tester) async {
    // arrange
    when(() => multiBloc.connectivity.state).thenReturn(NoInternetConnection());

    // act
    await tester.pumpWidget(myApp);
    final dialog = find.byType(SizedBox);

    // assert
    expect(dialog, findsOneWidget);
  });

  testWidgets(
    'should launch auth page \n'
    "when launching app with internet but Unauthenticated",
    (tester) async {
      // arrange
      when(() => multiBloc.connectivity.state)
          .thenReturn(HasInternetConnection());
      when(() => multiBloc.userSettings.state)
          .thenReturn(UserSettingsLoading());
      when(() => multiBloc.auth.state).thenReturn(AuthUnauthenticated());

      // act
      await tester.pumpWidget(myApp);
      final authPage = find.byType(AuthPage);

      // assert
      expect(authPage, findsOneWidget);
    },
  );
}
