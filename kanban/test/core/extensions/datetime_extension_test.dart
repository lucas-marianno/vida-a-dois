import 'package:flutter_test/flutter_test.dart';
import 'package:kanban/core/extensions/datetime_extension.dart';
import 'package:kanban/core/i18n/l10n.dart';

void main() async {
  group('with `Locale("en")`', () {
    late final AppLocalizations l10n;

    setUpAll(() async => l10n = await L10n.from('en'));

    test('should return a localized Short Date', () {
      final mockDate = DateTime(1994, 9, 16);
      final localizedShortDate = mockDate.toShortDate(l10n);

      expect(localizedShortDate, '09/16/1994');
    });

    test('should a padded Short Date', () {
      final mockDate = DateTime(2001, 2, 1);

      final localizedShortDate = mockDate.toShortDate(l10n);
      expect(localizedShortDate, '02/01/2001');
    });

    test('should not omit current year from Short Date', () {
      final currentYear = DateTime.now().year;
      final mockDate = DateTime(currentYear, 9, 1);
      final shortDate = mockDate.toShortDate(l10n);

      expect(shortDate, '09/01/$currentYear');
    });

    test('should return a localized Abbreviated Date', () {
      final mockDate = DateTime(1994, 9, 16);
      final abbreviatedDate = mockDate.toAbreviatedDate(l10n).toUpperCase();

      expect(abbreviatedDate, 'SEP 16 1994');
    });

    test('should return a padded Abbreviated Date', () {
      final mockDate = DateTime(1994, 9, 1);
      final abbreviatedDate = mockDate.toAbreviatedDate(l10n).toUpperCase();

      expect(abbreviatedDate, 'SEP 01 1994');
    });

    test('should omit current year from Abbreviated Date', () {
      final currentYear = DateTime.now().year;
      final mockDate = DateTime(currentYear, 9, 1);
      final abbreviatedDate = mockDate.toAbreviatedDate(l10n).toUpperCase();

      expect(abbreviatedDate, 'SEP 01');
    });

    test('should return a localized Long Date', () {
      final mockDate = DateTime(1994, 9, 16);
      final abbreviatedDate = mockDate.toLongDate(l10n);

      expect(abbreviatedDate, 'September 16, 1994');
    });
  });

  group('with `Locale("pt")`', () {
    late final AppLocalizations l10n;

    setUpAll(() async => l10n = await L10n.from('pt'));

    test('should return a localized Short Date', () {
      final mockDate = DateTime(1994, 9, 16);
      final localizedShortDate = mockDate.toShortDate(l10n);

      expect(localizedShortDate, '16/09/1994');
    });

    test('should a padded Short Date', () {
      final mockDate = DateTime(2001, 2, 1);

      final localizedShortDate = mockDate.toShortDate(l10n);
      expect(localizedShortDate, '01/02/2001');
    });

    test('should not omit current year from Short Date', () {
      final currentYear = DateTime.now().year;
      final mockDate = DateTime(currentYear, 9, 1);
      final shortDate = mockDate.toShortDate(l10n);

      expect(shortDate, '01/09/$currentYear');
    });

    test('should return a localized Abbreviated Date', () {
      final mockDate = DateTime(1994, 9, 16);
      final abbreviatedDate = mockDate.toAbreviatedDate(l10n).toUpperCase();

      expect(abbreviatedDate, '16 SET 1994');
    });

    test('should return a padded Abbreviated Date', () {
      final mockDate = DateTime(1994, 9, 1);
      final abbreviatedDate = mockDate.toAbreviatedDate(l10n).toUpperCase();

      expect(abbreviatedDate, '01 SET 1994');
    });

    test('should omit current year from Abbreviated Date', () {
      final currentYear = DateTime.now().year;
      final mockDate = DateTime(currentYear, 9, 1);
      final abbreviatedDate = mockDate.toAbreviatedDate(l10n).toUpperCase();

      expect(abbreviatedDate, '01 SET');
    });

    test('should return a localized Long Date', () {
      final mockDate = DateTime(1994, 9, 16);
      final abbreviatedDate = mockDate.toLongDate(l10n);

      expect(abbreviatedDate, '16 de setembro, 1994');
    });
  });
}
