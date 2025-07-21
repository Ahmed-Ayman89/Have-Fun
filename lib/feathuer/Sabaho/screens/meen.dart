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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'مين في الصورة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF232526), Color(0xFF0f2027), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
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
              aspectRatio: 2 / 1,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _displayedImages.length,
                itemBuilder: (context, index) {
                  final question = _displayedImages[index];
                  final isFlipped = _flippedCardIndexes.contains(index);
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildFlippableImageCard(
                        context, question, isFlipped, index),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'انقر على الصورة لإظهار الإجابة',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _shuffleQuestions,
        backgroundColor: const Color(0xFF36D1C4),
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text(
          'جولة جديدة',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: 20,
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
        color: isActive ? const Color(0xFF36D1C4) : Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildFlippableImageCard(
      BuildContext context, QuestionModel question, bool isFlipped, int index) {
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
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 16,
        shadowColor: const Color(0xFF36D1C4).withOpacity(0.25),
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
              : _buildCardImage(context, question.imageUrl, isFlipped),
        ),
      ),
    );
  }

  Widget _buildCardFace(String title, String answer, bool isFlipped) {
    final players = answer
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return Container(
      key: ValueKey(isFlipped),
      color: const Color(0xFF232526),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF36D1C4),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: players
                    .map((name) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardImage(
      BuildContext context, String imageUrl, bool isFlipped) {
    return Stack(
      key: ValueKey(!isFlipped),
      children: [
        Positioned.fill(
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(Icons.fullscreen, color: Colors.white.withOpacity(0.8)),
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
        onTap: () =>
            Navigator.pop(context), // On tap, return to the previous page
        child: Center(
          child: Hero(
            tag: imageUrl, // Use Hero animation for a smooth transition
            child: InteractiveViewer(
              minScale: 0.7,
              maxScale: 4.0,
              child: Image.asset(
                imageUrl,
                fit: BoxFit
                    .contain, // Display the entire image within the screen
              ),
            ),
          ),
        ),
      ),
    );
  }
}
