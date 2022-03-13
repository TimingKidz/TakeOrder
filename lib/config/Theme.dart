import 'package:flutter/material.dart';

class BaseApplicationTheme {
  static ThemeData of(context) {
    ThemeData theme = Theme.of(context);
    return theme.copyWith();
  }
}