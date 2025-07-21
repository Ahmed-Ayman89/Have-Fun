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
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF232526), Color(0xFF0f2027), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'أسئلة عشوائية',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 18),
                    // Fun icon/logo
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.18),
                            blurRadius: 30,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/main_logo.jpeg',
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Modern team score card
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 22),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.group,
                                  color: Colors.cyanAccent, size: 32),
                              const SizedBox(height: 4),
                              Text(
                                'فريق أ',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Text(
                                '$teamAScore',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyanAccent,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => increaseTeamScore('A'),
                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.greenAccent, size: 26),
                                  ),
                                  IconButton(
                                    onPressed: () => decreaseTeamScore('A'),
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.redAccent, size: 26),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 22),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.group,
                                  color: Colors.amberAccent, size: 32),
                              const SizedBox(height: 4),
                              Text(
                                'فريق ب',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Text(
                                '$teamBScore',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amberAccent,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => increaseTeamScore('B'),
                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.greenAccent, size: 26),
                                  ),
                                  IconButton(
                                    onPressed: () => decreaseTeamScore('B'),
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.redAccent, size: 26),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        questions[currentQuestionIndex]['question'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    ...questions[currentQuestionIndex]['options'].map((option) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 60),
                            backgroundColor: getButtonColor(option),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shadowColor:
                                getButtonColor(option) == AppColors.darkBlue
                                    ? AppColors.glowBlue.withOpacity(0.5)
                                    : getButtonColor(option).withOpacity(0.7),
                            elevation: 14,
                          ),
                          onPressed: () => checkAnswer(option),
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
