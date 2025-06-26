import 'package:flutter/material.dart';
import '../../../../../core/utils/App_colors.dart'; // تأكد من تحديث your_app_name

class GameHeaderWidget extends StatelessWidget {
  const GameHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ودجت لعرض نقاط الفريق
  Widget buildTeamScoreDisplay(String teamName, int score) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(teamName,
            style: const TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: 18,
                fontFamily: 'Cairo')),
        Text('$score',
            style: const TextStyle(
                color: AppColors.glowBlue,
                fontSize: 32,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ودجت لأزرار التحكم (بدء/إيقاف المؤقت)
  Widget buildControlButton(
      String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cardBgDark, // خلفية داكنة للأزرار
          foregroundColor: AppColors.pureWhite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontFamily: 'Cairo')),
    );
  }
}
