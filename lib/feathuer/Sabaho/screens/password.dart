import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/data/player_data.dart';

class PasworChalleng extends StatefulWidget {
  const PasworChalleng({super.key});

  @override
  State<PasworChalleng> createState() => _PasworChallengState();
}

class _PasworChallengState extends State<PasworChalleng> {
  PlayerModel? randomPlayer;
  int teamAScore = 0;
  int teamBScore = 0;

  void getPlayerRandom() {
    final random = Random();
    setState(() {
      randomPlayer = players[random.nextInt(players.length)];
    });
  }

  void increaseTeamScore(String team) {
    setState(() {
      if (team == 'A') {
        teamAScore++;
      } else if (team == 'B') {
        teamBScore++;
      }
    });
  }

  void decreaseTeamScore(String team) {
    setState(() {
      if (team == 'A' && teamAScore > 0) {
        teamAScore--;
      } else if (team == 'B' && teamBScore > 0) {
        teamBScore--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF232526), Color(0xFF0f2027), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'اسماء لاعبين',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTeamScoreColumn('الفريق أ', teamAScore, 'A'),
                    buildTeamScoreColumn('الفريق ب', teamBScore, 'B'),
                  ],
                ),
              ),
              const Divider(
                color: Colors.white24,
                thickness: 1,
                height: 1,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                  scale: animation, child: child),
                            );
                          },
                          child: randomPlayer != null
                              ? _buildPlayerCard(randomPlayer!)
                              : _buildInitialView(),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF36D1C4),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 10,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 18),
                          ),
                          onPressed: getPlayerRandom,
                          icon: const Icon(Icons.person_search, size: 28),
                          label: const Text(
                            'اعرض لاعب',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTeamScoreColumn(String teamName, int teamScore, String team) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              team == 'A' ? Icons.sports_esports : Icons.sports_soccer,
              color: team == 'A'
                  ? const Color(0xFF36D1C4)
                  : const Color(0xFF5B86E5),
              size: 28,
              shadows: [const Shadow(color: Colors.black26, blurRadius: 4)],
            ),
            const SizedBox(width: 6),
            Text(
              teamName,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  shadows: [Shadow(color: Colors.black38, blurRadius: 6)]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: team == 'A'
                    ? const Color(0xFF36D1C4).withOpacity(0.18)
                    : const Color(0xFF5B86E5).withOpacity(0.18),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            '$teamScore',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: team == 'A'
                    ? const Color(0xFF36D1C4)
                    : const Color(0xFF5B86E5),
                fontFamily: 'Cairo',
                shadows: [const Shadow(color: Colors.black26, blurRadius: 4)]),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => increaseTeamScore(team),
              icon: const Icon(Icons.add_circle_outline,
                  color: Colors.greenAccent, size: 28),
              splashRadius: 22,
            ),
            IconButton(
              onPressed: () => decreaseTeamScore(team),
              icon: const Icon(Icons.remove_circle_outline,
                  color: Colors.redAccent, size: 28),
              splashRadius: 22,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerCard(PlayerModel player) {
    return Container(
      key: ValueKey(player.name),
      padding: const EdgeInsets.all(24.0),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF232526), Color(0xFF2c5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.18),
                  blurRadius: 30,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                player.image,
                fit: BoxFit.contain,
                width: 120,
                height: 120,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            player.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
                shadows: [Shadow(color: Colors.black54, blurRadius: 8)]),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              player.position,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF36D1C4),
                  fontFamily: 'Cairo'),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: player.clubs.map((club) {
              return Chip(
                label: Text(
                  club,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                backgroundColor: const Color(0xFF36D1C4).withOpacity(0.8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialView() {
    return Column(
      key: const ValueKey('initial'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.person_search,
            size: 120,
            color: Colors.white70,
            shadows: [Shadow(color: Colors.black45, blurRadius: 12)]),
        const SizedBox(height: 20),
        const Text(
          'هل أنت مستعد للتحدي؟',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
            shadows: [
              Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2))
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'اضغط على زر "اعرض لاعب" لبدء اللعبة',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white70,
            fontFamily: 'Cairo',
            shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
          ),
        ),
      ],
    );
  }
}
