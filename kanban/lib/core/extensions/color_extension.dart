import 'package:flutter/material.dart';

extension Transparency on Color {
  Color addTransparency([int alpha = 158]) {
    return Color.fromARGB(alpha, red, green, blue);
  }
}
