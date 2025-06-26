import 'package:flutter/material.dart';

import '../../../../../core/utils/App_colors.dart'; // تأكد من تحديث your_app_name

class DiceRollSection extends StatelessWidget {
  final String activeDiceImage;
  final int diceRoll;
  final VoidCallback onRollDice;
  final bool isDisabled; // لتعطيل الزر

  const DiceRollSection({
    super.key,
    required this.activeDiceImage,
    required this.diceRoll,
    required this.onRollDice,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          activeDiceImage,
          width: 100,
          height: 100,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.warningColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '$diceRoll',
                  style: const TextStyle(
                    color: AppColors.pureWhite,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 200,
          height: 60,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.glowBlue,
              foregroundColor: AppColors.pureWhite,
              elevation: 10,
              shadowColor: AppColors.glowBlue.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: isDisabled
                ? null
                : onRollDice, // تعطيل الزر إذا كان isDisabled صحيحًا
            icon: const Icon(Icons.casino_outlined, size: 28),
            label: const Text(
              'Roll',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
