import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vida_a_dois/app/app.dart';
import 'package:vida_a_dois/features/user_settings/domain/entities/user_settings.dart';

import '../../helper/mock_blocs.dart';

void main() async {
  late Widget myApp;
  final multiMockBloc = MultiMockBloc();
  myApp = multiMockBloc.provideWithBlocs(const VidaADoidApp());

  group('l10n test', () {
    setUp(() {
      when(() => multiMockBloc.connectivity.state)
          .thenReturn(HasInternetConnection());
      when(() => multiMockBloc.auth.state).thenReturn(AuthUnauthenticated());
    });

    testWidgets('should launch the app in portuguese', (tester) async {
      // arrange
      final userSettingsPT = UserSettings(
        uid: 'uid',
        userName: 'userName',
        themeMode: ThemeMode.light,
        locale: const Locale('pt'),
        initials: 'un',
      );
      when(() => multiMockBloc.userSettings.state)
          .thenReturn(UserSettingsLoaded(userSettingsPT));

      // act
      await tester.pumpWidget(myApp);
      final portugueseTitle = find.text('Vida a dois');

      // assert
      expect(portugueseTitle, findsOneWidget);
    });
    testWidgets('should launch the app in english', (tester) async {
      // arrange
      final userSettingsEN = UserSettings(
        uid: 'uid',
        userName: 'userName',
        themeMode: ThemeMode.light,
        locale: const Locale('en'),
        initials: 'un',
      );
      when(() => multiMockBloc.userSettings.state)
          .thenReturn(UserSettingsLoaded(userSettingsEN));

      // act
      await tester.pumpWidget(myApp);
      final portugueseTitle = find.text("A Couple's Life");

      // assert
      expect(portugueseTitle, findsOneWidget);
    });
  });
}
