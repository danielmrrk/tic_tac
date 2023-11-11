import 'package:flutter/material.dart';
import 'package:tic_tac/database/statistic/user_statistic.dart';
import 'package:tic_tac/game/difficulty_card.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';

class RankDisplay extends StatelessWidget {
  const RankDisplay({super.key, required this.userStatistic});
  final double strokeHeight = 4;
  final UserStatistic? userStatistic;

  @override
  Widget build(BuildContext context) {
    Difficulty difficultyDisplay = Difficulty.fromDatabaseRank(userStatistic?.rank ?? "");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "RANK",
              style: TTTextTheme.bodyLargeSemiBold,
            ),
            const SizedBox(height: 44),
            Text(
              difficultyDisplay.displayName,
              style: TTTextTheme.colorfulTitle,
            )
          ],
        ),
        Stack(
          children: [
            DifficultyCard(
              difficultyDisplay: difficultyDisplay,
              strokeColor: Colors.white,
              height: 180,
              width: 208,
              rankImage: true,
            ),
            Positioned(
              bottom: strokeHeight,
              left: strokeHeight,
              child: Container(
                height: 28,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: difficultyDisplay.color.withOpacity(0.9),
                ),
                child: Center(
                  child: Text(
                    "${userStatistic?.rankExp ?? "Loading"} / "
                    "${difficultyDisplay.expRequiredForRankUp}",
                    style: TTTextTheme.bodyMedium,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}