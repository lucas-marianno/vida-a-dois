import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/core/i18n/l10n.dart';

void main() async {
  group('l10n test', () {
    testWidgets('should launch the app in english', (tester) async {
      // arrange
      const locale = Locale('en');
      final l10n = await AppLocalizations.delegate.load(locale);
      const app = MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Material(child: DummyWidget()),
      );

      // act
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // assert
      // expect(find.text('null'), findsOneWidget); // finds 1 widget
      expect(find.text(l10n.appTitle), findsOneWidget); // finds 0 widgets
    });
  });
}

class DummyWidget extends StatelessWidget {
  const DummyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final title = AppLocalizations.of(context)?.appTitle;
    return Scaffold(
      body: Center(
        child: Text(title ?? 'null'),
      ),
    );
  }
}
