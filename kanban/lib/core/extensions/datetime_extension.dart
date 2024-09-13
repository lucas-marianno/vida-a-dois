import 'package:kanban/core/i18n/l10n.dart';

extension LocalizedDateTime on DateTime {
  /// Returns a localized `Short Date` as `String`
  ///
  /// ``` dart
  /// final deadline = DateTime(1994, 9, 16);
  ///
  /// final en = await L10n.from('en');
  /// final localizedShortDate = deadline.toShortDate(en); // "09/16/1994"
  ///
  /// final pt = await L10n.from('pt');
  /// final localizedShortDate = deadline.toShortDate(pt); // "16/09/1994"
  /// ```
  String toShortDate(AppLocalizations l10n) {
    String date = l10n.dateShort(day, month, year);

    return date.splitMapJoin('/', onNonMatch: (d) => d.length == 1 ? '0$d' : d);
  }

  /// Returns a localized `Abbreviated Date` as `String`
  ///
  /// ``` dart
  /// final deadline = DateTime(1994, 9, 16);
  ///
  /// final en = await L10n.from('en');
  /// final localizedShortDate = deadline.toAbreviatedDate(en); // "sep 16 1994"
  ///
  /// final pt = await L10n.from('pt');
  /// final localizedShortDate = deadline.toAbreviatedDate(pt); // "16 set 1994"
  /// ```
  String toAbreviatedDate(AppLocalizations l10n) {
    String date = l10n.dateAbbreviated(
      day,
      getLocalizedMonth(l10n).substring(0, 3),
      year,
    );
    return date
        .splitMapJoin(' ', onNonMatch: (d) => d.length == 1 ? '0$d' : d)
        .replaceAll(DateTime.now().year.toString(), '')
        .trim();
  }

  /// Returns a localized `Long Date` as `String`
  ///
  /// ``` dart
  /// final deadline = DateTime(1994, 9, 16);
  ///
  /// final en = await L10n.from('en');
  /// final localizedShortDate = deadline.toLongDate(en); // "September 16, 1994"
  ///
  /// final pt = await L10n.from('pt');
  /// final localizedShortDate = deadline.toLongDate(pt); // "16 de Setembro, 1994"
  /// ```
  String toLongDate(AppLocalizations l10n) {
    return l10n.dateLong(day, getLocalizedMonth(l10n), year);
  }

  String getLocalizedMonth(AppLocalizations l10n) {
    return {
      1: l10n.january,
      2: l10n.february,
      3: l10n.march,
      4: l10n.april,
      5: l10n.may,
      6: l10n.june,
      7: l10n.july,
      8: l10n.august,
      9: l10n.september,
      10: l10n.october,
      11: l10n.november,
      12: l10n.december,
    }[month]!;
  }
}
