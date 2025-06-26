import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:havefun/core/data/meen_data.dart';

import '../../../core/utils/App_colors.dart'; // Importing the user's data file

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
    return Scaffold(
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
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _displayedImages.length,
              (index) => _buildPageIndicator(index == _currentPageIndex),
            ),
          ),
          const SizedBox(height: 20),
          // Page viewer for images
          AspectRatio(
            aspectRatio: 2 / 1, // Aspect ratio for images (width/height)
            child: PageView.builder(
              controller: _pageController,
              itemCount: _displayedImages.length,
              itemBuilder: (context, index) {
                final question = _displayedImages[index];
                final isFlipped = _flippedCardIndexes.contains(index);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildFlippableImageCard(
                      context, question, isFlipped, index), // Pass context
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Instructional text
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
      // "New Round" button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _shuffleQuestions, // On press, shuffle questions
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
    );
  }

  // Function to build page indicators
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

  // Function to build a flippable image card
  Widget _buildFlippableImageCard(
      BuildContext context, QuestionModel question, bool isFlipped, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact(); // Light vibration on tap
        setState(() {
          if (isFlipped) {
            _flippedCardIndexes.remove(index); // Remove card from flipped set
          } else {
            _flippedCardIndexes.add(index); // Add card to flipped set
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
          duration: const Duration(milliseconds: 600), // Animation duration
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
              ? _buildCardFace(
                  'الإجابة', question.answer, isFlipped) // Display answer
              : _buildCardImage(context, question.imageUrl,
                  isFlipped), // Display image (with fullscreen button)
        ),
      ),
    );
  }

  // Function to build the image display interface (front of the card)
  Widget _buildCardImage(
      BuildContext context, String imageUrl, bool isFlipped) {
    return Stack(
      key: ValueKey(isFlipped), // Key to track state in AnimatedSwitcher
      children: [
        Positioned.fill(
          child: Image.asset(
            imageUrl,
            fit: BoxFit
                .cover, // Fill available space while maintaining aspect ratio
          ),
        ),
        // Fullscreen button
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(Icons.fullscreen,
                color: AppColors.pureWhite.withOpacity(0.8)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImagePage(imageUrl: imageUrl),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to build the answer display interface (back of the card)
  Widget _buildCardFace(String title, String content, bool isFlipped) {
    return Container(
      key: ValueKey(isFlipped), // Key to track state in AnimatedSwitcher
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

// New page to display the image in fullscreen mode
class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background for fullscreen
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context); // On tap, return to the previous page
        },
        child: Center(
          child: Hero(
            tag: imageUrl, // Use Hero animation for a smooth transition
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain, // Display the entire image within the screen
            ),
          ),
        ),
      ),
    );
  }
}
