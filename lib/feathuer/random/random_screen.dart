import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/data/quiz_data.dart';
import '../../core/utils/App_colors.dart';

class Quizsceen extends StatefulWidget {
  const Quizsceen({super.key});

  @override
  State<Quizsceen> createState() => _QuizsceenState();
}

class _QuizsceenState extends State<Quizsceen> {
  int currentQuestionIndex = 0;
  int score = 0;
  final Random random = Random();
  int teamAScore = 0;
  int teamBScore = 0;

  // -- متغيرات جديدة لتتبع حالة الإجابة --
  String? selectedAnswer;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    questions.shuffle(random);
  }

  void checkAnswer(String option) {
    // لا تسمح بالضغط مرة أخرى بعد الإجابة
    if (isAnswered) return;

    setState(() {
      selectedAnswer = option;
      isAnswered = true;
    });

    final isCorrect =
        selectedAnswer == questions[currentQuestionIndex]['answer'];

    if (isCorrect) {
      score++;
      // لا داعي لـ SnackBar هنا لأن اللون سيوضح الإجابة
    }

    // تأخير قبل الانتقال للسؤال التالي لإظهار اللون
    Future.delayed(const Duration(milliseconds: 1200), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        // -- إعادة تعيين حالة الإجابة للسؤال الجديد --
        selectedAnswer = null;
        isAnswered = false;
      } else {
        showResultDialog();
      }
    });
  }

  void resetQuiz() {
    Navigator.of(context).pop();
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
      isAnswered = false;
      questions.shuffle(random);
    });
  }

  void showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // لا يمكن إغلاق الـ Dialog بالضغط خارجه
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryBackground,
        title: Text(
          'الامتحان انتهى!',
          style: TextStyle(color: AppColors.pureWhite),
        ),
        content: Text(
          'النتيجة النهائية: $score/${questions.length}',
          style: TextStyle(color: AppColors.primaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: resetQuiz,
            child: Text(
              'إعادة الاختبار',
              style: TextStyle(color: AppColors.glowBlue),
            ),
          ),
        ],
      ),
    );
  }

  // -- دالة لتحديد لون الزر بناءً على الحالة --
  Color getButtonColor(String option) {
    if (!isAnswered) {
      // اللون الافتراضي قبل الإجابة
      return AppColors.darkBlue;
    }

    // إذا كانت هذه هي الإجابة الصحيحة
    if (option == questions[currentQuestionIndex]['answer']) {
      return AppColors.successColor; // أخضر
    }

    // إذا كانت هذه هي إجابة المستخدم الخاطئة
    if (option == selectedAnswer) {
      return AppColors.errorColor; // أحمر
    }

    // بقية الخيارات غير المحددة
    return AppColors.darkBlue;
  }

  // (بقية الدوال مثل increase/decreaseTeamScore و buildTeamScoreColumn تبقى كما هي)
  void increaseTeamScore(String team) {
    setState(() {
      if (team == 'A') {
        teamAScore++;
      } else if (team == 'B') {
        teamBScore++;
      }
    });
  }

  void decreaseTeamScore(String team) {
    setState(() {
      if (team == 'A' && teamAScore > 0) {
        teamAScore--;
      } else if (team == 'B' && teamBScore > 0) {
        teamBScore--;
      }
    });
  }

  Column buildTeamScoreColumn(String teamName, int teamScore, String team) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          teamName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTextColor,
          ),
        ),
        Text(
          '$teamScore',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.glowBlue,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => increaseTeamScore(team),
              icon: const Icon(Icons.add),
              color: AppColors.successColor,
            ),
            IconButton(
              onPressed: () => decreaseTeamScore(team),
              icon: const Icon(Icons.remove),
              color: AppColors.errorColor,
            ),
          ],
        ),
      ],
    );
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
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryTextColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'أسئلة دينيه',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTeamScoreColumn('فريق أ', teamAScore, 'A'),
                  buildTeamScoreColumn('فريق ب', teamBScore, 'B'),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                questions[currentQuestionIndex]['question'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 40),
              ...questions[currentQuestionIndex]['options'].map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getButtonColor(option),
                      foregroundColor: AppColors.pureWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shadowColor: getButtonColor(option) == AppColors.darkBlue
                          ? AppColors.glowBlue.withOpacity(0.5)
                          : getButtonColor(option).withOpacity(0.7),
                      elevation: 10,
                    ),
                    onPressed: () => checkAnswer(option),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
