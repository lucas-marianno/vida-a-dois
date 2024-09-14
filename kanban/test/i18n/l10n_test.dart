import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kanban/core/i18n/l10n.dart';

import '../helper/testable_app.dart';

class _DummyWidget extends StatelessWidget {
  const _DummyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(L10n.of(context).appTitle),
    );
  }
}

void main() async {
  group('l10n test', () {
    testWidgets('should launch the app in portuguese', (tester) async {
      // arrange
      final l10n = await L10n.from('pt');

      // act
      await tester.pumpWidget(const TestableApp(
        _DummyWidget(),
        languageCode: 'pt',
      ));
      await tester.pumpAndSettle();

      // assert
      final portugueseTitle = find.text(l10n.appTitle);
      expect(portugueseTitle, findsOneWidget);
    });

    testWidgets('should launch the app in english', (tester) async {
      // arrange
      final l10n = await L10n.from('en');

      // act
      await tester.pumpWidget(const TestableApp(
        _DummyWidget(),
        languageCode: 'en',
      ));
      await tester.pumpAndSettle();

      // assert
      final portugueseTitle = find.text(l10n.appTitle);
      expect(portugueseTitle, findsOneWidget);
    });
  });
}
