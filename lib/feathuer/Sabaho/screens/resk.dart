import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/data/resk_data.dart';
import '../../../core/utils/App_colors.dart';

class ReskPage extends StatefulWidget {
  const ReskPage({super.key});

  @override
  _ReskPageState createState() => _ReskPageState();
}

class _ReskPageState extends State<ReskPage> {
  late List<Category> _displayedCategories;
  // مجموعة لتتبع الأسئلة التي تمت إجابتها لمنع تكرارها
  final Set<String> _answeredQuestions = {};
  // لتتبع السؤال المفتوح حالياً
  String? _currentlyFlippedId;

  int _time = 45;
  Timer? _timer;
  int _team1Points = 0;
  int _team2Points = 0;

  @override
  void initState() {
    super.initState();
    _shuffleCategories();
  }

  void _shuffleCategories() {
    final random = Random();
    final allCategories = List.from(categories);
    allCategories.shuffle(random);
    setState(() {
      _displayedCategories = allCategories.take(4).toList().cast<Category>();
    });
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_time > 0) {
        setState(() => _time--);
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetGame() {
    _stopTimer();
    setState(() {
      _time = 45;
      _team1Points = 0;
      _team2Points = 0;
      _answeredQuestions.clear();
      _currentlyFlippedId = null;
      _shuffleCategories();
    });
  }

  void _awardPoints(int points, int teamNumber) {
    setState(() {
      if (teamNumber == 1) {
        _team1Points += points;
      } else {
        _team2Points += points;
      }
      // إضافة السؤال المفتوح إلى قائمة الأسئلة المجابة وإغلاقه
      if (_currentlyFlippedId != null) {
        _answeredQuestions.add(_currentlyFlippedId!);
      }
      _currentlyFlippedId = null;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            'ريسك',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              _buildHeader(),
              const Divider(color: AppColors.darkBlue, thickness: 1.5),
              Expanded(
                child: ListView.builder(
                  itemCount: _displayedCategories.length,
                  itemBuilder: (context, index) {
                    final category = _displayedCategories[index];
                    return _buildCategoryCard(category);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets البناء ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTeamScore('الفريق 1', _team1Points),
              _buildTimerDisplay(),
              _buildTeamScore('الفريق 2', _team2Points),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                  'إيقاف', Icons.pause, AppColors.darkBlue, _stopTimer),
              _buildControlButton('بدء/استئناف', Icons.play_arrow,
                  AppColors.glowBlue, _startTimer),
              _buildControlButton(
                  'إعادة', Icons.refresh, AppColors.errorColor, _resetGame),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamScore(String teamName, int score) {
    return Column(
      children: [
        Text(teamName,
            style: const TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: 18,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold)),
        Text('$score',
            style: const TextStyle(
                color: AppColors.glowBlue,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTimerDisplay() {
    final isDangerTime = _time <= 10 && _time > 0;
    return Column(
      children: [
        Text('الوقت',
            style: const TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: 18,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold)),
        Text('$_time',
            style: TextStyle(
                color:
                    isDangerTime ? AppColors.errorColor : AppColors.pureWhite,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildControlButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontFamily: 'Cairo')),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Card(
      color: AppColors.darkBlue,
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: AppColors.glowBlue.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              category.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.glowBlue,
                  fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 8),
            Text(
              category.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.secondaryTextColor,
                  fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 20),
            ...category.questions
                .map((q) => _buildQuestionWidget(q, category))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(Question question, Category category) {
    final questionId = '${category.title}-${question.questionText}';
    final isAnswered = _answeredQuestions.contains(questionId);
    final isFlipped = _currentlyFlippedId == questionId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return SizeTransition(sizeFactor: animation, child: child);
        },
        child: isFlipped
            ? _buildFlippedView(question)
            : _buildNormalView(question, questionId, isAnswered),
      ),
    );
  }

  Widget _buildNormalView(
      Question question, String questionId, bool isAnswered) {
    return ElevatedButton(
      key: ValueKey('normal-$questionId'),
      onPressed: isAnswered
          ? null
          : () => setState(() => _currentlyFlippedId = questionId),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBackground,
        disabledBackgroundColor: AppColors.primaryBackground.withOpacity(0.4),
        foregroundColor: AppColors.pureWhite,
        disabledForegroundColor: AppColors.secondaryTextColor.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 5,
      ),
      child: Text(
        '${question.points} نقاط - ${question.questionText}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
          decoration:
              isAnswered ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildFlippedView(Question question) {
    return Container(
      key: ValueKey('flipped-${question.questionText}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.glowBlue)),
      child: Column(
        children: [
          Text('الإجابة: ${question.answer}',
              style: const TextStyle(
                  color: AppColors.successColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 10),
          const Text('لمن تذهب النقاط؟',
              style: TextStyle(
                  color: AppColors.primaryTextColor, fontFamily: 'Cairo')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () => _awardPoints(question.points, 1),
                  child: Text('فريق 1 (+${question.points})',
                      style: const TextStyle(
                          color: AppColors.glowBlue, fontFamily: 'Cairo'))),
              TextButton(
                  onPressed: () => _awardPoints(question.points, 2),
                  child: Text('فريق 2 (+${question.points})',
                      style: const TextStyle(
                          color: AppColors.glowBlue, fontFamily: 'Cairo'))),
            ],
          )
        ],
      ),
    );
  }
}
