import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/button_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac/main_sceen/difficulty_grid.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff271045),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(31, 100, 31, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Choose your difficulty",
                style: GoogleFonts.bebasNeue(fontSize: 36, color: const Color(0xffB552DE), fontWeight: FontWeight.w400)),
            const SizedBox(height: 20),
            const DifficultyGrid(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const TTButton(title: "New Game").fullWidthButton,
                  const SizedBox(height: 8),
                  const TTButton(title: "Stats & Challenges").fullWidthButton,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}