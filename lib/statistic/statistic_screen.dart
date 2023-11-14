import 'package:flutter/material.dart';
import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/database/statistic/challenge_data.dart';
import 'package:tic_tac/database/statistic/statistic_database.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/statistic/challenge_item.dart';
import 'package:tic_tac/statistic/rank_display.dart';
import 'package:tic_tac/statistic/statistic_display.dart';
import 'package:tic_tac/statistic/user_statistic_service.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});
  @override
  StatisticScreenState createState() => StatisticScreenState();
}

class StatisticScreenState extends State<StatisticScreen> {
  Map<String, String>? _userStatistic;
  List<Challenge> _challenges = [];
  final key = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    initUserStatistic();
    initChallenges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_challenges.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistic'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                RankDisplay(userStatistic: _userStatistic),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    childAspectRatio: 1.6,
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      StatisticDisplay(
                        userStatistic: _userStatistic,
                        displayValue: _userStatistic?[kWinKey] ?? '0',
                        imagePath: 'assets/images/trophy.png',
                        detailData: kWinKey,
                        clickable: true,
                      ),
                      StatisticDisplay(
                        userStatistic: _userStatistic,
                        displayValue: _userStatistic?[kDrawKey] ?? '0',
                        imagePath: 'assets/images/balance-scale.png',
                        detailData: kDrawKey,
                        clickable: true,
                      ),
                      StatisticDisplay(
                        userStatistic: _userStatistic,
                        displayValue: _userStatistic?[kLossKey] ?? '0',
                        imagePath: 'assets/images/skull.png',
                        detailData: kLossKey,
                        clickable: true,
                      ),
                      StatisticDisplay(
                        displayValue: "${_userStatistic?[kWinRate] ?? '0'}%",
                        imagePath: 'assets/images/trophy_skull.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.7,
            snap: true,
            builder: (context, controller) => Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                gradient: LinearGradient(
                  colors: [Color(0xff3e1277), Color(0xff4d1e8b)],
                  stops: [0, 0.7],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: _challenges.isNotEmpty
                  ? AnimatedList(
                      key: key,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      controller: controller,
                      initialItemCount: _challenges.length + 1,
                      itemBuilder: ((context, index, animation) {
                        return index == 0
                            ? Padding(
                                key: const ValueKey("Mastery Challenges"),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Mastery Challenges",
                                  style: TTTextTheme.strikingTitle,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ChallengeItem(
                                key: ValueKey(_challenges[index - 1].content),
                                challenge: _challenges[index - 1],
                                onRemoveClearedChallenge: () {
                                  setState(() {
                                    onRemoveClearedChallenge(_challenges[index - 1], index - 1, context);
                                  });
                                },
                              );
                      }),
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }

  void initUserStatistic() async {
    final Map<String, String> userStatistic = await UserStatisticService.instance.readAllUserStats();
    setState(() {
      _userStatistic = userStatistic;
    });
  }

  void initChallenges() async {
    List<Challenge> challenges = await StatisticDatabase.instance.readAllShowableChallenges();
    setState(() {
      _challenges = challenges;
    });
  }

  void onRemoveClearedChallenge(Challenge challenge, int correctIndex, BuildContext context) {
    _challenges.removeAt(correctIndex);
    key.currentState!.removeItem(
      correctIndex + 1,
      (context, animation) => SizeTransition(
        sizeFactor: animation.drive(
          Tween(begin: 0, end: 1),
        ),
        child: ChallengeItem(
          challenge: _challenges[correctIndex],
          onRemoveClearedChallenge: onRemoveClearedChallenge,
        ),
      ),
    );
  }
}
