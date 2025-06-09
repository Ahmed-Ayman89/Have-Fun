import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/data/player_data.dart';
import '../../../core/utils/App_colors.dart';

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
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackground,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryTextColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'اسماء لاعبين',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTeamScoreColumn('الفريق أ', teamAScore, 'A'),
                  buildTeamScoreColumn('الفريق ب', teamBScore, 'B'),
                ],
              ),
            ),
            const Divider(
              color: AppColors.darkBlue,
              thickness: 1,
              height: 1,
            ),

            // تم استخدام Expanded لإعطاء هذا الجزء كل المساحة المتبقية
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // ================== بداية التعديل ==================
                // تم تغليف الـ Column بـ SingleChildScrollView ليسمح بالتمرير
                child: SingleChildScrollView(
                  child: Column(
                    // تم تغيير MainAxisAlignment لأن SingleChildScrollView يتعارض مع spaceBetween
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child:
                                ScaleTransition(scale: animation, child: child),
                          );
                        },
                        child: randomPlayer != null
                            ? _buildPlayerCard(randomPlayer!)
                            : _buildInitialView(),
                      ),

                      // إضافة مسافة يدوية بين البطاقة والزر
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.glowBlue,
                            foregroundColor: AppColors.pureWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.glowBlue.withOpacity(0.5),
                          ),
                          onPressed: getPlayerRandom,
                          icon: const Icon(Icons.shuffle, size: 24),
                          label: Text(
                            randomPlayer == null ? 'اعرض لاعب' : 'لاعب جديد',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ================== نهاية التعديل ==================
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialView() {
    // ... الكود هنا يبقى كما هو
    return Column(
      key: const ValueKey('initial'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.person_search, size: 120, color: AppColors.darkBlue),
        const SizedBox(height: 20),
        const Text(
          'هل أنت مستعد للتحدي؟',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'اضغط على زر "اعرض لاعب" لبدء اللعبة',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.secondaryTextColor,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(PlayerModel player) {
    // ... الكود هنا يبقى كما هو
    return Container(
      key: ValueKey(player.name),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.darkBlue.withOpacity(0.8),
            AppColors.primaryBackground,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.pureBlack.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        // تم حذف SingleChildScrollView من هنا لأن التمرير أصبح في الأعلى
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.glowBlue.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                player.image,
                width: 180,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            player.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.pureWhite,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            '(${player.position})',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.secondaryTextColor,
              fontFamily: 'Cairo',
            ),
          ),
          const Divider(
            color: AppColors.darkBlue,
            thickness: 1,
            height: 25,
            indent: 40,
            endIndent: 40,
          ),
          const Text(
            'الأندية التي لعب لها',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: player.clubs.map((club) {
              return Chip(
                label: Text(
                  club,
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                backgroundColor: AppColors.glowBlue.withOpacity(0.8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Column buildTeamScoreColumn(String teamName, int teamScore, String team) {
    // ... الكود هنا يبقى كما هو
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          teamName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          '$teamScore',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.glowBlue,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => increaseTeamScore(team),
              icon: const Icon(Icons.add_circle, color: AppColors.successColor),
            ),
            IconButton(
              onPressed: () => decreaseTeamScore(team),
              icon:
                  const Icon(Icons.remove_circle, color: AppColors.errorColor),
            ),
          ],
        ),
      ],
    );
  }
}
