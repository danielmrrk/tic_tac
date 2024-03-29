import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:tic_tac/game/game_provider.dart';
import 'package:tic_tac/game/game_screen.dart';
import 'package:tic_tac/general/theme/button_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/general/util/snackbar.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:tic_tac/main_sceen/difficulty_grid.dart';
import 'package:tic_tac/statistic/statistic_screen.dart';
import 'package:tic_tac/statistic/user_statistic_service.dart';

final images = [
  "grey_drunkard.png",
  "drunkard.png",
  "edited_drunkard.png",
  "rank_drunkard.png",
  "grey_novice.png",
  "novice.png",
  "edited_novice.png",
  "rank_novice.png",
  "grey_white_knight.png",
  "white_knight.png",
  "edited_white_knight.png",
  "rank_white_knight.png",
  "grey_dark_wizard.png",
  "dark_wizard.png",
  "edited_dark_wizard.png",
  "rank_dark_wizard.png",
  "trophy.png",
  "balance-scale.png",
  "skull.png",
  "trophy_skull.png",
];

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, this.reset = false});

  final bool reset;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with WidgetsBindingObserver {
  Difficulty? _selectedDifficulty;
  late bool _reset;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // init state before
    precache();
    _reset = widget.reset;
    if (_reset) {
      for (var rank in Difficulty.ranks) {
        rank.focused = false;
      }
      _reset = false;
      ref.read(gameProvider.notifier).clear();
    }
    ref.read(userStatisticProvider);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      precache();
    }
    super.didChangeAppLifecycleState(state);
  }

  void precache() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var image in images) {
        precacheImage(AssetImage("assets/images/$image"), context);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(31, 100, 31, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose your difficulty",
              style: TTTextTheme.strikingColorfulTitle,
            ),
            const SizedBox(height: 20),
            DifficultyGrid(
              setSelectedDifficulty: setSelectedDifficulty,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const TTButton(title: "New Game").fullWidthButton(
                    () {
                      if (_selectedDifficulty == null) {
                        showSimpleGetSnackbar("Please select a difficulty", 3);
                        return;
                      }

                      ref.read(timeProvider.notifier).startTimer(_selectedDifficulty!);

                      Get.to(() => GameScreen(difficulty: _selectedDifficulty!));
                    },
                  ),
                  const SizedBox(height: 8),
                  const TTButton(title: "Stats & Challenges").fullWidthButton(() {
                    Get.to(() => const StatisticScreen());
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void setSelectedDifficulty(Difficulty rank) {
    _selectedDifficulty = rank.focused ? rank : null;
  }
}
