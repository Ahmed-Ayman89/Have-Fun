import 'dart:math';
import 'package:flutter/material.dart';

// تأكد من أن هذا المسار صحيح وأن الملف يحتوي على دالة shuffleQuestionsAndOptions
import '../../core/data/denea_data.dart';
import '../../core/data/quiz_data.dart';
import '../../core/utils/App_colors.dart';

class DeenPage extends StatefulWidget {
  const DeenPage({super.key});

  @override
  State<DeenPage> createState() => _DeenPageState();
}

class _DeenPageState extends State<DeenPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  final Random random = Random();
  int teamAScore = 0;
  int teamBScore = 0;

  // -- متغيرات الحالة الجديدة --
  int zekrCount = 0; // عداد الذكر (السبحة)
  String? selectedAnswer;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    // خلط الأسئلة والخيارات عند بدء التشغيل
    shuffleQuestionsAndOptions(deenData);
  }

  // --- دوال التحكم بالسبحة ---
  void incrementZekrCount() {
    setState(() {
      zekrCount++;
    });
  }

  void resetZekrCount() {
    setState(() {
      zekrCount = 0;
    });
  }

  // --- دوال التحكم بالاختبار ---
  void checkAnswer(String option) {
    if (isAnswered) return;

    setState(() {
      isAnswered = true;
      selectedAnswer = option;
      if (option == deenData[currentQuestionIndex]['answer']) {
        score++;
      }
    });

    // تأخير للانتقال للسؤال التالي
    Future.delayed(const Duration(milliseconds: 1200), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < deenData.length - 1) {
        currentQuestionIndex++;
        isAnswered = false;
        selectedAnswer = null;
      } else {
        showResultDialog();
      }
    });
  }

  void resetQuiz() {
    Navigator.of(context).pop();
    // إعادة خلط الأسئلة والخيارات
    shuffleQuestionsAndOptions(deenData);
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      isAnswered = false;
      selectedAnswer = null;
      teamAScore = 0; // يمكنك اختيار إعادة تعيين نقاط الفرق أو لا
      teamBScore = 0;
    });
  }

  void showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryBackground,
        title: const Text(
          'اكتمل الاختبار',
          style: TextStyle(color: AppColors.pureWhite, fontFamily: 'Cairo'),
          textAlign: TextAlign.right,
        ),
        content: Text(
          'نتيجتك النهائية: <span class="math-inline">score/</span>{deenData.length}',
          style: const TextStyle(
              color: AppColors.primaryTextColor, fontFamily: 'Cairo'),
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: resetQuiz,
            child: const Text(
              'إعادة الاختبار',
              style: TextStyle(
                  color: AppColors.glowBlue,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- دوال التحكم بنقاط الفرق ---
  void increaseTeamScore(String team) {
    setState(() {
      if (team == 'A')
        teamAScore++;
      else if (team == 'B') teamBScore++;
    });
  }

  void decreaseTeamScore(String team) {
    setState(() {
      if (team == 'A' && teamAScore > 0)
        teamAScore--;
      else if (team == 'B' && teamBScore > 0) teamBScore--;
    });
  }

  // دالة لتحديد لون الزر
  Color getButtonColor(String option) {
    if (!isAnswered) {
      return AppColors.darkBlue; // اللون الافتراضي
    }
    if (option == deenData[currentQuestionIndex]['answer']) {
      return AppColors.successColor; // اللون الأخضر للإجابة الصحيحة
    }
    if (option == selectedAnswer) {
      return AppColors.errorColor; // اللون الأحمر للإجابة الخاطئة المختارة
    }
    return AppColors.darkBlue;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackground,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'أسئلة دينية',
            style: TextStyle(
                color: AppColors.pureWhite,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo'), // استخدام خط مميز
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.pureWhite),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- عرض نقاط الفرق ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTeamScoreColumn('الفريق أ', teamAScore, 'A'),
                  buildTeamScoreColumn('الفريق ب', teamBScore, 'B'),
                ],
              ),
              const SizedBox(height: 15),

              // --- السبحة الإلكترونية ---
              buildZekrCounter(),

              const Divider(
                  color: AppColors.darkBlue, thickness: 1, height: 30),

              // --- قسم الأسئلة ---
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        deenData[currentQuestionIndex]['question'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22, // حجم أكبر للسؤال
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTextColor,
                          fontFamily: 'Cairo',
                          height: 1.5, // لتباعد الأسطر
                        ),
                      ),
                      const SizedBox(height: 25),
                      ...deenData[currentQuestionIndex]['options']
                          .map((option) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(450, 50),
                              backgroundColor: getButtonColor(option),
                              foregroundColor: AppColors.pureWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 8,
                              shadowColor:
                                  getButtonColor(option).withOpacity(0.5),
                            ),
                            onPressed: () => checkAnswer(option),
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ودجت لبناء السبحة ---
  Widget buildZekrCounter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.pureBlack.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            "سبحان الله وبحمده، سبحان الله العظيم",
            style: TextStyle(
              color: AppColors.primaryTextColor,
              fontSize: 18,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // زر إعادة العداد للصفر
              IconButton(
                icon: const Icon(Icons.refresh,
                    color: AppColors.glowBlue, size: 28),
                onPressed: resetZekrCount,
              ),
              // عرض عدد التسبيحات
              Text(
                '$zekrCount',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite,
                ),
              ),
              // زر التسبيح
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.glowBlue,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: incrementZekrCount,
                  child: const Text(
                    'سبّح',
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- ودجت لبناء أعمدة نقاط الفرق ---
  Column buildTeamScoreColumn(String teamName, int teamScore, String team) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          teamName,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.pureWhite,
              fontFamily: 'Cairo'),
        ),
        Text(
          '$teamScore',
          style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.glowBlue),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => increaseTeamScore(team),
              icon: const Icon(Icons.add, color: AppColors.successColor),
            ),
            IconButton(
              onPressed: () => decreaseTeamScore(team),
              icon: const Icon(Icons.remove, color: AppColors.errorColor),
            ),
          ],
        ),
      ],
    );
  }
}
