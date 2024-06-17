import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plagia_detect/shared/styles/Colors.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: lightBgColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'IBMPlexSansArabic',
  appBarTheme: AppBarTheme(
    backgroundColor: lightBgColor,
    elevation: 0,
    scrolledUnderElevation: 0.0,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: const TextStyle(
      fontSize: 18.0,
      letterSpacing: 0.6,
      color: Colors.black,
      fontFamily: 'IBMPlexSansArabic',
      fontWeight: FontWeight.bold,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: lightBgColor,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: lightBgColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),
  colorScheme: ColorScheme.light(
    primary: lightPrimaryColor,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: lightBgColor,
  ),
);


ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: darkColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'IBMPlexSansArabic',
  appBarTheme: AppBarTheme(
    backgroundColor: darkColor,
    elevation: 0,
    scrolledUnderElevation: 0.0,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: const TextStyle(
      fontSize: 18.0,
      letterSpacing: 0.6,
      color: Colors.white,
      fontFamily: 'IBMPlexSansArabic',
      fontWeight: FontWeight.bold,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: darkColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: darkColor,
        systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),
  colorScheme: ColorScheme.dark(
    primary: darkPrimaryColor,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: darkIndicator,
  ),
);



// --------------------------------------------- //

FeedbackThemeData lightThemeFeedback = FeedbackThemeData(
  background: Colors.grey.shade700,
  feedbackSheetColor: lightBgColor,
  colorScheme: ColorScheme.light(
    primary: lightPrimaryColor,
  ),
  bottomSheetDescriptionStyle: const TextStyle(
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    letterSpacing: 0.6,
  ),
  activeFeedbackModeColor: lightPrimaryColor,
  dragHandleColor: lightPrimaryColor,
  sheetIsDraggable: true,
  bottomSheetTextInputStyle: const TextStyle(
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
    letterSpacing: 0.6,
  ),
  drawColors: [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ],
);



FeedbackThemeData darkThemeFeedback = FeedbackThemeData(
  background: Colors.grey.shade300,
  feedbackSheetColor: darkColor,
  colorScheme: ColorScheme.dark(
    primary: darkPrimaryColor,
  ),
  bottomSheetDescriptionStyle: const TextStyle(
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    letterSpacing: 0.6,
  ),
  activeFeedbackModeColor: darkPrimaryColor,
  dragHandleColor: darkPrimaryColor,
  sheetIsDraggable: true,
  bottomSheetTextInputStyle: const TextStyle(
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
    letterSpacing: 0.6,
  ),
  drawColors: [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ],
);