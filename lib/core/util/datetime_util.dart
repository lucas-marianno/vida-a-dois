class DateTimeUtil {
  static String dateTimeToStringBrazilDateOnly(DateTime dateTime) {
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();

    day = _padWithZeroUpTo(day, 2);
    month = _padWithZeroUpTo(month, 2);

    return '$day/$month/$year';
  }

  static String _padWithZeroUpTo(String string, int desiredLength) {
    if (string.length >= desiredLength) return string;

    for (int i = 0; i < desiredLength - string.length; i++) {
      string = '0$string';
    }
    return string;
  }
}
