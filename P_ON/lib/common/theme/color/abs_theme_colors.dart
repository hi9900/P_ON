import 'package:p_on/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

export 'package:p_on/common/constant/app_colors.dart';

typedef ColorProvider = Color Function();

abstract class AbstractThemeColors {
  const AbstractThemeColors();

  Color get seedColor => const Color(0xff26ff8c);

  Color get veryBrightGrey => AppColors.brightGrey;

  Color get drawerBg => const Color.fromARGB(255, 255, 255, 255);

  Color get scrollableItem => const Color.fromARGB(255, 57, 57, 57);

  Color get iconButton => const Color.fromARGB(255, 255, 255, 255);

  Color get navButton => const Color.fromARGB(255, 0, 102, 255);

  Color get navButtonInactivate => const Color.fromARGB(255, 0, 0, 0);

  Color get iconButtonInactivate => const Color.fromARGB(255, 113, 113, 113);

  Color get inActivate => const Color.fromARGB(255, 79, 79, 79);

  Color get activate => const Color.fromARGB(255, 63, 72, 95);

  Color get badgeBg => AppColors.blueGreen;

  Color get textBadgeText => Colors.white;

  Color get badgeBorder => Colors.transparent;

  Color get divider => const Color.fromARGB(255, 80, 80, 80);

  Color get text => Colors.white;

  Color get hintText => AppColors.middleGrey;

  Color get focusedBorder => AppColors.darkGrey;

  Color get confirmText => AppColors.blue;

  Color get drawerText => text;

  Color get snackbarBgColor => AppColors.mediumBlue;

  Color get blueButtonBackground => AppColors.darkBlue;

  Color get appBarBackground => const Color.fromARGB(255, 255, 255, 255);

  Color get buttonBackground => const Color.fromARGB(255, 48, 48, 48);

  Color get roundedLayoutBackground => const Color.fromARGB(255, 255, 255, 255);

  Color get listLayoutBackground => const Color.fromARGB(255, 228, 232, 239);

  Color get dateTimeCloseLayoutBackground => const Color.fromARGB(255, 51, 59, 79);

  Color get unreadColor => const Color.fromARGB(255, 48, 48, 48);

  Color get lessImportant => AppColors.grey;

  Color get blueText => AppColors.blue;

  Color get floatingActionLayer => const Color.fromARGB(255, 37, 37, 39);

  Color get dimmedText => const Color.fromARGB(255, 171, 171, 171);

  Color get plus => const Color.fromARGB(255, 230, 71, 83);

  Color get minus => const Color.fromARGB(255, 57, 127, 228);
}
