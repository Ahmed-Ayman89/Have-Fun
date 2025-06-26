import 'package:flutter/material.dart';

import '../../../../../core/utils/App_colors.dart';
import 'Challenge.dart';
import 'player_model.dart'; // تأكد من تحديث your_app_name

// مودال عرض سؤال الكارت الأصفر
class YellowCardQuestionModal extends StatelessWidget {
  final Challenge challenge;
  final String currentPlayerName;
  final VoidCallback onAnswered;

  const YellowCardQuestionModal({
    super.key,
    required this.challenge,
    required this.currentPlayerName,
    required this.onAnswered,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        'تحدي لـ $currentPlayerName!',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            challenge.question, // السؤال
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primaryTextColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'للعلم: الإجابة الصحيحة هي: "${challenge.answer}"', // عرض الإجابة الصحيحة للمرجع
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryTextColor.withOpacity(0.8),
              fontSize: 16,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onAnswered, // إغلاق مودال السؤال وفتح مودال تعديل النقاط
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.glowBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'انتقل لتقييم النقاط',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 18,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }
}

// مودال تعديل نقاط اللاعب الفردي (من قبل الحكم)
class IndividualPlayerScoreModal extends StatelessWidget {
  final List<Player> players;
  final Function(String playerId, int points) onAdjustScore;
  final VoidCallback onClose; // لغلق المودال

  const IndividualPlayerScoreModal({
    super.key,
    required this.players,
    required this.onAdjustScore,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        'تعديل نقاط اللاعبين',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      content: SizedBox(
        // تحديد ارتفاع لمنع التجاوز
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      player
                          .icon, // <--- تم تغيير هذا السطر لاستخدام الـ Widget مباشرة
                      const SizedBox(width: 10),
                      Text(
                        '${player.name}: ${player.score} نقطة',
                        style: const TextStyle(
                          color: AppColors.primaryTextColor,
                          fontSize: 18,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle,
                            color: AppColors.dangerColor),
                        onPressed: () =>
                            onAdjustScore(player.id, -3), // -3 نقاط
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle,
                            color: AppColors.successColor),
                        onPressed: () => onAdjustScore(player.id, 3), // +3 نقاط
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: onClose, // إغلاق المودال
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.glowBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'تم',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 18,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }
}

// مودال نهاية اللعبة
class GameEndModal extends StatelessWidget {
  final int team1Score;
  final int team2Score;
  final VoidCallback onStartNewGame;

  const GameEndModal({
    super.key,
    required this.team1Score,
    required this.team2Score,
    required this.onStartNewGame,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Icon(Icons.emoji_events,
          size: 64, color: AppColors.warningColor),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'اللعبة انتهت!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            team1Score > team2Score
                ? 'الفريق 1 هو الفائز! ($team1Score نقطة)'
                : team2Score > team1Score
                    ? 'الفريق 2 هو الفائز! ($team2Score نقطة)'
                    : 'تعادل! ($team1Score نقطة)',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.glowBlue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onStartNewGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.glowBlue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'ابدأ لعبة جديدة',
              style: TextStyle(
                color: AppColors.pureWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
