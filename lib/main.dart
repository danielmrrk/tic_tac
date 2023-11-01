import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/main_screen.dart';

void main() {
  runApp(const TicTacApp());
}

class TicTacApp extends StatelessWidget {
  const TicTacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xff271045),
          filledButtonTheme: const FilledButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xffb552de)),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: TTTextTheme.bodyMedium,
            backgroundColor: TTColorTheme.onBackground,
          ),
          appBarTheme: const AppBarTheme(backgroundColor: TTColorTheme.background, elevation: 0)),
    );
  }
}
