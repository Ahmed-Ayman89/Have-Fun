import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // **تمت الإضافة من أجل الاستجابة اللمسية**

import '../../../core/data/ehbd_data.dart';
import '../../../core/utils/App_colors.dart';

class Ehbedpage extends StatefulWidget {
  const Ehbedpage({super.key});

  @override
  State<Ehbedpage> createState() => _EhbedpageState();
}

class _EhbedpageState extends State<Ehbedpage> {
  late List<QuestionModel> _displayedQuestions;
  late PageController _pageController;
  final Set<int> _flippedCardIndexes = {};
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.85);
    _pageController.addListener(() {
      setState(() {
        if (_pageController.page != null) {
          _currentPageIndex = _pageController.page!.round();
        }
      });
    });
    _shuffleQuestions();
  }

  void _shuffleQuestions() {
    final random = Random();
    final allQuestions = List.from(questionCard);
    allQuestions.shuffle(random);

    setState(() {
      _displayedQuestions = allQuestions.take(5).toList().cast<QuestionModel>();
      _flippedCardIndexes.clear();
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      _currentPageIndex = 0;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            'اهبد صح',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _displayedQuestions.length,
                (index) => _buildPageIndicator(index == _currentPageIndex),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _displayedQuestions.length,
                itemBuilder: (context, index) {
                  final question = _displayedQuestions[index];
                  final isFlipped = _flippedCardIndexes.contains(index);

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildFlippableCard(question, isFlipped, index),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'انقر على البطاقة لإظهار الإجابة',
              style: TextStyle(
                color: AppColors.secondaryTextColor,
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _shuffleQuestions,
          backgroundColor: AppColors.glowBlue,
          icon: const Icon(Icons.refresh, color: AppColors.pureWhite),
          label: const Text(
            'جولة جديدة',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 12,
      width: isActive ? 24 : 12,
      decoration: BoxDecoration(
        color: isActive ? AppColors.glowBlue : AppColors.darkBlue,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildFlippableCard(
      QuestionModel question, bool isFlipped, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        setState(() {
          if (isFlipped) {
            _flippedCardIndexes.remove(index);
          } else {
            _flippedCardIndexes.add(index);
          }
        });
      },
      child: Card(
        // الكود هنا كما هو
        color: AppColors.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        shadowColor: AppColors.glowBlue.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
              return AnimatedBuilder(
                animation: rotateAnim,
                child: child,
                builder: (context, child) {
                  final isUnder = (ValueKey(isFlipped) != child!.key);
                  var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                  tilt *= isUnder ? -1.0 : 1.0;
                  final value = min(rotateAnim.value, pi / 2);
                  return Transform(
                    transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
              );
            },
            child: isFlipped
                ? _buildCardFace('الإجابة', question.answer, index, isFlipped,
                    AppColors.successColor)
                : _buildCardFace('السؤال', question.question, index, isFlipped,
                    AppColors.primaryTextColor),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFace(String title, String content, int index, bool isFlipped,
      Color textColor) {
    return Container(
      key: ValueKey(isFlipped),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryTextColor,
                    fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 15),
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.5,
                    fontFamily: 'Cairo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
