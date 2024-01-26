import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

ThemeData baseTheme(BuildContext context) {
  final ThemeData base = ThemeData(fontFamily: 'nanum');
  return base.copyWith(
    brightness: Brightness.light,
    //배경 색
    scaffoldBackgroundColor: CustomColors.whiteBackground,
    //appbar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: true,
      toolbarHeight: 75,
    ),
    //textStyle
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'nanum',
          bodyColor: CustomColors.mainBlack,
          displayColor: CustomColors.mainBlack,
        ),
    popupMenuTheme: PopupMenuThemeData(
      surfaceTintColor: CustomColors.whiteBackground, // 원하는 배경 색으로 변경
    ),
    //dialog
    dialogBackgroundColor: Colors.white,
  );
}
