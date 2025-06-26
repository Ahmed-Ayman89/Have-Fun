import 'package:flutter/material.dart';

import '../../../../../core/utils/App_colors.dart';
import '../model/Challenge.dart';

class ChallengeCardWidget extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onAnswered;
  final bool isDisabled; // لتعطيل الزر إذا كان هناك مودال آخر مفتوح

  const ChallengeCardWidget({
    super.key,
    required this.challenge,
    required this.onAnswered,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBgDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      shadowColor: AppColors.glowBlue.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    challenge.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                      height: 1.5,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ),
            const Divider(color: AppColors.glowBlue, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton.icon(
                onPressed: isDisabled
                    ? null
                    : onAnswered, // تعطيل الزر إذا كان isDisabled صحيحًا
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successColor,
                  foregroundColor: AppColors.pureWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.check, size: 20),
                label: const Text(
                  'أجبت',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
