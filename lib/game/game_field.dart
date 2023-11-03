import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tic_tac/game/game_provider.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/util/array_position_2d.dart';
import 'package:tic_tac/general/util/dialog.dart';

class GameField extends ConsumerStatefulWidget {
  const GameField({
    super.key,
    required this.resetTimer,
    required this.cancelTimer,
  });

  final Function resetTimer;
  final Function cancelTimer;

  @override
  ConsumerState<GameField> createState() => _GameFieldState();
}

class _GameFieldState extends ConsumerState<GameField> {
  bool _isOver = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(48, 44, 48, 14),
      color: TTColorTheme.onBackground,
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(9, (index) {
          int row = index ~/ 3;
          int col = index % 3;
          return GestureDetector(
            onTap: () {
              if (!_isOver) {
                _isOver = ref.read(gameProvider.notifier).onPlayerPlacedMove(row, col);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              color: TTColorTheme.background,
              child: ref.read(gameProvider.notifier).board[row][col] != "' '"
                  ? SvgPicture.asset(
                      "assets/images/${ref.read(gameProvider.notifier).board[row][col].replaceAll("'", "")}.svg",
                    )
                  : null,
            ),
          );
        }),
      ),
    );
  }
}
