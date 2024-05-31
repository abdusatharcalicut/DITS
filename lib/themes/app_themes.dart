import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData of(BuildContext context) => Theme.of(context);
  
  static const primaryColorDark = Color.fromARGB(255, 49, 100, 158);
  static const secondaryColor = Color(0xFFC99E23);
  static const tertiaryColor = Color(0xFFF2F2F4);
  
  static final lightTheme =
      ThemeData(brightness: Brightness.light,fontFamily: "OpenSans").copyWith(
    primaryColor: primaryColorDark,
    primaryColorDark: secondaryColor,
    colorScheme:
        ThemeData.light().colorScheme.copyWith(primary: primaryColorDark),
  );
}

extension CustomThemeData on ThemeData {
  Color get customLabelColor => brightness == Brightness.light
      ? const Color(0xFF000000)
      : const Color(0xFFF2F2F4);

  Color get customBlackColor => brightness == Brightness.light
      ? const Color(0xFF000000)
      : const Color(0xFFF2F2F4);

  Color get customWhiteColor => brightness == Brightness.light
      ? const Color(0xFFF2F2F4)
      : const Color(0xFF000000);

  Color get customRedColor => const Color(0xFFFE346E);
}
