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
    final bool isCurrentPlayerOnSquare = players.isNotEmpty &&
        playersOnSquare.any((p) => p.id == players[currentPlayerIndex].id);

    Color borderColor = Colors.transparent;
    Color bgColor = AppColors.darkBlue;
    Color textColor = AppColors.primaryTextColor;
    Gradient? gradient;
    Widget? badge;

    if (square.type == 'yellowCard') {
      bgColor = AppColors.warningColor;
      textColor = AppColors.secondaryBackground;
      gradient = LinearGradient(colors: [AppColors.warningColor.withOpacity(0.9), AppColors.warningColor.withOpacity(0.6)]);
      badge = Positioned(
        top: 6,
        left: 6,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 13,
          child: Icon(Icons.star, color: AppColors.warningColor, size: 18),
        ),
      );
    } else if (square.type == 'redCard') {
      bgColor = AppColors.dangerColor;
      textColor = AppColors.pureWhite;
      gradient = LinearGradient(colors: [AppColors.dangerColor.withOpacity(0.9), AppColors.dangerColor.withOpacity(0.6)]);
      badge = Positioned(
        top: 6,
        left: 6,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 13,
          child: Icon(Icons.warning, color: AppColors.dangerColor, size: 18),
        ),
      );
    } else {
      gradient = LinearGradient(colors: [AppColors.darkBlue.withOpacity(0.95), AppColors.primaryBackground.withOpacity(0.7)]);
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
        gradient: gradient,
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.18),
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (badge != null) badge,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: Text(
                      square.content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        fontFamily: 'Cairo',
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '(${index + 1})',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 12,
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
                          p.icon,
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
        crossAxisCount: 10, // 10 columns
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.5,
      ),
      itemCount: 30, // 3 rows x 10 columns
      itemBuilder: (context, index) {
        return _buildGridItem(
          index < board.length
              ? board[index]
              : BoardSquare(
                  type: 'normal', content: '', question: null, answer: null),
          index,
        );
      },
    );
  }
}
