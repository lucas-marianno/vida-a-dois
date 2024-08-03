import 'dart:math';
import 'package:flutter/material.dart';

extension IconExtension on Icon {
  Widget flipVertical() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi),
      child: this,
    );
  }

  Widget flipHorizontal() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationX(pi),
      child: this,
    );
  }
}
