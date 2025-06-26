import 'package:flutter/material.dart';

import '../../../../../core/utils/App_colors.dart';
import 'Challenge.dart';

// مودال عرض التحدي (Challenge Modal)
class ChallengeDisplayModal extends StatelessWidget {
  final Challenge challenge;
  final String currentPlayerName;
  final VoidCallback onNavigateToScoreEvaluation;

  const ChallengeDisplayModal({
    super.key,
    required this.challenge,
    required this.currentPlayerName,
    required this.onNavigateToScoreEvaluation,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryTextColor,
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
          onPressed: onNavigateToScoreEvaluation,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.glowBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'انتقل لتقييم النقاط (للفريق)',
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

// مودال تعديل نقاط الفريق يدوياً
class ManualTeamScoreModal extends StatelessWidget {
  final String currentPlayerName;
  final Challenge currentChallenge;
  final Function(int teamNumber, int points) onApplyPoints;

  const ManualTeamScoreModal({
    super.key,
    required this.currentPlayerName,
    required this.currentChallenge,
    required this.onApplyPoints,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryTextColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        'تقييم إجابة $currentPlayerName',
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
            'السؤال كان: "${currentChallenge.question}"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryTextColor.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'الإجابة الصحيحة: "${currentChallenge.answer}"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryTextColor.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'أعطِ نقاطًا للفريق:',
            style: TextStyle(
              color: AppColors.primaryTextColor,
              fontSize: 16,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => onApplyPoints(1, 3), // إضافة 3 نقاط للفريق 1
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: AppColors.pureWhite),
                label: const Text(
                  '+3 لـ 1',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => onApplyPoints(1, -3), // خصم 3 نقاط من الفريق 1
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.remove, color: AppColors.pureWhite),
                label: const Text(
                  '-3 من 1',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => onApplyPoints(2, 3), // إضافة 3 نقاط للفريق 2
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: AppColors.pureWhite),
                label: const Text(
                  '+3 لـ 2',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => onApplyPoints(2, -3), // خصم 3 نقاط من الفريق 2
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.remove, color: AppColors.pureWhite),
                label: const Text(
                  '-3 من 2',
                  style: TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
