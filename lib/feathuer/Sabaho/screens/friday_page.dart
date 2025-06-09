import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/data/all_data.dart';
import '../../../core/utils/App_colors.dart';

class FridayPage extends StatefulWidget {
  const FridayPage({super.key});

  @override
  State<FridayPage> createState() => _FridayPageState();
}

class _FridayPageState extends State<FridayPage> {
  final Random _random = Random();
  List<String> currentItems = [];
  int? selectedIndex; // لتخزين رقم الخانة المختارة
  String activeDiceImage = 'assets/images/dice-1.png';

  @override
  void initState() {
    super.initState();
    // بدء اللعبة بقائمة جديدة عند فتح الشاشة
    changeData();
  }

  // دالة للحصول على قائمة جديدة من التحديات
  void changeData() {
    setState(() {
      // اختيار قائمة عشوائية من البيانات الرئيسية
      currentItems = allData[_random.nextInt(allData.length)];
      // إعادة تعيين الاختيار السابق والنرد
      selectedIndex = null;
      activeDiceImage = 'assets/images/dice-1.png';
    });
  }

  void rollDiceAndSelectItem() {
    if (currentItems.isEmpty) return;
    setState(() {
      int newIndex = _random.nextInt(currentItems.length);
      selectedIndex = newIndex;
      int diceRoll = _random.nextInt(6) + 1;
      activeDiceImage = 'assets/images/dice-$diceRoll.png';
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
          title: const Text(
            'الكورة و اللاين مان',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: true,
          actions: [
            // زر لتغيير البيانات (تحدي جديد)
            IconButton(
              icon: const Icon(Icons.refresh,
                  size: 28, color: AppColors.glowBlue),
              tooltip: 'تحدي جديد',
              onPressed: changeData,
            ),
          ],
        ),
        // استخدام SingleChildScrollView لتجنب مشاكل الـ Overflow
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- الشبكة ---
                GridView.builder(
                  shrinkWrap: true, // مهم جداً داخل SingleChildScrollView
                  physics:
                      const NeverScrollableScrollPhysics(), // لمنع التمرير داخل الشبكة
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: currentItems.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return buildGridItem(currentItems[index], isSelected);
                  },
                ),
                const SizedBox(height: 30),

                // --- عرض النتيجة المختارة ---
                buildResultDisplay(),

                const SizedBox(height: 20),

                // --- صورة النرد ---
                Image.asset(
                  activeDiceImage,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 30),

                // --- زر Roll ---
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
                    onPressed: rollDiceAndSelectItem,
                    icon: const Icon(Icons.casino_rounded, size: 28),
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
            ),
          ),
        ),
      ),
    );
  }

  /// ودجت لعرض نتيجة الاختيار مع تأثير حركي
  Widget buildResultDisplay() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.5),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: selectedIndex != null
          ? Text(
              currentItems[selectedIndex!],
              key: ValueKey(currentItems[selectedIndex!]), // مهم للحركة
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.successColor, // لون أخضر للنتيجة
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            )
          : const SizedBox(
              key: ValueKey('empty'), height: 40), // يحافظ على المساحة
    );
  }

  /// ودجت لبناء خلية الشبكة مع تأثير حركي عند الاختيار
  Widget buildGridItem(String text, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.successColor : AppColors.darkBlue,
        borderRadius: BorderRadius.circular(15),
        border: isSelected
            ? Border.all(color: AppColors.pureWhite, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: (isSelected ? AppColors.successColor : AppColors.glowBlue)
                .withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Cairo',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
