import 'package:flutter/material.dart';

import '../../../../../core/utils/App_colors.dart';
import '../model/board_square.dart';
import '../model/player_model.dart';

class BoardGridWidget extends StatelessWidget {
  final List<BoardSquare> board;
  final List<Player> players;
  final int currentPlayerIndex;

  const BoardGridWidget({
    super.key,
    required this.board,
    required this.players,
    required this.currentPlayerIndex,
  });

  // ودجت بناء خلية الشبكة (المربعات على اللوحة)
  Widget _buildGridItem(BoardSquare square, int index) {
    final playersOnSquare = players.where((p) => p.position == index).toList();
    // تأكد أن قائمة اللاعبين ليست فارغة قبل محاولة الوصول إلى _players[currentPlayerIndex].id
    final bool isCurrentPlayerOnSquare = players.isNotEmpty &&
        playersOnSquare.any((p) => p.id == players[currentPlayerIndex].id);

    Color borderColor = Colors.transparent;
    Color bgColor = AppColors.darkBlue; // لون افتراضي
    Color textColor = AppColors.primaryTextColor;

    if (square.type == 'yellowCard') {
      bgColor = AppColors.warningColor;
      textColor = AppColors.secondaryBackground;
    } else if (square.type == 'redCard') {
      bgColor = AppColors.dangerColor;
      textColor = AppColors.pureWhite;
    }

    if (isCurrentPlayerOnSquare) {
      borderColor = AppColors.pureWhite;
    } else if (playersOnSquare.isNotEmpty) {
      borderColor = AppColors.glowBlue;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                square.content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // حجم أصغر قليلاً لاستيعاب النصوص الطويلة
                  fontFamily: 'Cairo',
                ),
                maxLines: 3, // <--- تم زيادة الحد الأقصى للأسطر هنا
                overflow: TextOverflow.ellipsis, // إضافة ... للنصوص الطويلة
              ),
              Text(
                '(${index + 1})',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 10,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 4,
            child: Wrap(
              spacing: 2,
              runSpacing: 2,
              children: playersOnSquare
                  .map((p) => Stack(
                        children: [
                          p.icon, // <--- تم تغيير هذا السطر لاستخدام الـ Widget مباشرة
                          if (players.isNotEmpty &&
                              p.id == players[currentPlayerIndex].id)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                              ),
                            ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: board.length,
      itemBuilder: (context, index) {
        return _buildGridItem(board[index], index);
      },
    );
  }
}
