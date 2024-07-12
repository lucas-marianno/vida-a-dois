import 'dart:ui';

class ColorUtil {
  static Color makeTransparencyFrom(Color color) {
    return Color.fromARGB(158, color.red, color.green, color.blue);
  }
}
