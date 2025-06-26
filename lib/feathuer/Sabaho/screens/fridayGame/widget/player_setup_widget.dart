import 'package:flutter/material.dart';

import '../../../../../core/utils/App_colors.dart';

class PlayerSetupWidget extends StatefulWidget {
  final int numPlayers;
  final Function(int) onNumPlayersChanged;
  final List<TextEditingController> playerNameControllers;
  final VoidCallback onStartGame;

  const PlayerSetupWidget({
    super.key,
    required this.numPlayers,
    required this.onNumPlayersChanged,
    required this.playerNameControllers,
    required this.onStartGame,
  });

  @override
  State<PlayerSetupWidget> createState() => _PlayerSetupWidgetState();
}

class _PlayerSetupWidgetState extends State<PlayerSetupWidget> {
  // لا توجد حاجة لدالة _updatePlayerNameControllers هنا
  // لأنه تم تمرير الـ controllers من FridayPage

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'إعداد اللاعبين',
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => widget.onNumPlayersChanged(
                        (widget.numPlayers - 1)
                            .clamp(2, 2)), // محدد بـ 2 لاعب فقط
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: AppColors.pureWhite,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Icon(Icons.remove, size: 30),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${widget.numPlayers}',
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => widget.onNumPlayersChanged(
                        (widget.numPlayers + 1)
                            .clamp(2, 2)), // محدد بـ 2 لاعب فقط
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: AppColors.pureWhite,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Icon(Icons.add, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // حقول إدخال أسماء اللاعبين
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.numPlayers,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: widget.playerNameControllers[index],
                      style: const TextStyle(
                          color: AppColors.pureWhite, fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'اسم اللاعب ${index + 1}',
                        labelStyle: TextStyle(
                            color: AppColors.primaryTextColor.withOpacity(0.8)),
                        hintText: 'أدخل اسم اللاعب',
                        hintStyle: TextStyle(
                            color: AppColors.primaryTextColor.withOpacity(0.5)),
                        filled: true,
                        fillColor: AppColors.cardBgLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppColors.glowBlue, width: 2),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onStartGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.glowBlue,
                    foregroundColor: AppColors.pureWhite,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    shadowColor: AppColors.glowBlue.withOpacity(0.5),
                  ),
                  child: const Text(
                    'بدء اللعبة',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
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
}
