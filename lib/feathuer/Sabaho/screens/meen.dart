import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:havefun/core/data/meen_data.dart';
import '../../../core/utils/App_colors.dart';

class MeenPage extends StatefulWidget {
  const MeenPage({super.key});

  @override
  State<MeenPage> createState() => _MeenPageState();
}

class _MeenPageState extends State<MeenPage> {
  late List<QuestionModel> _displayedImages;
  late PageController _pageController;
  final Set<int> _flippedCardIndexes = {};
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPageIndex = _pageController.page!.round();
        });
      }
    });
    _shuffleQuestions();
  }

  void _shuffleQuestions() {
    final random = Random();
    final allQuestions = List.from(imgeCard);
    allQuestions.shuffle(random);

    setState(() {
      _displayedImages = allQuestions.take(5).toList().cast<QuestionModel>();
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
            'مين في الصورة',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _displayedImages.length,
                (index) => _buildPageIndicator(index == _currentPageIndex),
              ),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              // مثال: 1/1 لمربع, 4/5 لأقصر, 3/5 لأطول
              aspectRatio: 2 / 1,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _displayedImages.length,
                itemBuilder: (context, index) {
                  final question = _displayedImages[index];
                  final isFlipped = _flippedCardIndexes.contains(index);
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildFlippableImageCard(question, isFlipped, index),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'انقر على الصورة لإظهار الإجابة',
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
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 12,
      width: isActive ? 24 : 12,
      decoration: BoxDecoration(
        color: isActive ? AppColors.glowBlue : AppColors.darkBlue,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildFlippableImageCard(
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
        clipBehavior: Clip.antiAlias,
        color: AppColors.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        shadowColor: AppColors.glowBlue.withOpacity(0.4),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
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
              ? _buildCardFace('الإجابة', question.answer, isFlipped)
              : _buildCardImage(question.imageUrl, isFlipped),
        ),
      ),
    );
  }

  Widget _buildCardImage(String imageUrl, bool isFlipped) {
    return Container(
      key: ValueKey(isFlipped),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCardFace(String title, String content, bool isFlipped) {
    return Container(
      key: ValueKey(isFlipped),
      padding: const EdgeInsets.all(20),
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
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.successColor,
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
