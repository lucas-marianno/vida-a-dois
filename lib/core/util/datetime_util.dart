class DateTimeUtil {
  static String dateTimeToStringBrazilDateOnly(DateTime? dateTime) {
    if (dateTime == null) return '';

    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();

    day = _padWithZeroUpTo(day, 2);
    month = _padWithZeroUpTo(month, 2);

    return '$day/$month/$year';
  }

  static String dateTimeToStringShort(DateTime? dateTime) {
    if (dateTime == null) return '';

    String day = dateTime.day.toString();
    String month = _monthPTBR(dateTime.month).substring(0, 3);

    String year =
        DateTime.now().year == dateTime.year ? '' : dateTime.year.toString();

    day = _padWithZeroUpTo(day, 2);
    return '$day $month $year';
  }

  static String _padWithZeroUpTo(String string, int desiredLength) {
    if (string.length >= desiredLength) return string;

    for (int i = 0; i < desiredLength - string.length; i++) {
      string = '0$string';
    }
    return string;
  }

  static String _monthPTBR(int m) {
    assert(m > 0 && m <= 12);

    return {
      1: 'janeiro',
      2: 'fevereiro',
      3: 'março',
      4: 'abril',
      5: 'maio',
      6: 'junho',
      7: 'julho',
      8: 'agosto',
      9: 'setembro',
      10: 'outubro',
      11: 'novembro',
      12: 'dezembro',
    }[m]!;
  }
}
