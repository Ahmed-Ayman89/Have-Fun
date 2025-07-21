import 'package:flutter/material.dart';

import '../../../core/data/Top10_data.dart';
import '../../../core/utils/App_colors.dart';

class Top10Screen extends StatefulWidget {
  const Top10Screen({super.key});

  @override
  _Top10ScreenState createState() => _Top10ScreenState();
}

class _Top10ScreenState extends State<Top10Screen> {
  int _currentPage = 0;
  int _team1Points = 0;
  int _team2Points = 0;
  late PageController _pageController;
  late List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _questions = List<Map<String, dynamic>>.from(top10Data);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _shuffleQuestions() {
    setState(() {
      _questions.shuffle();
      _currentPage = 0;
      _pageController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'توب 10',
              style: TextStyle(
                color: AppColors.pureWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shuffle, color: AppColors.glowBlue),
              tooltip: 'عرض الأسئلة عشوائي',
              onPressed: _shuffleQuestions,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // شريط الفرق والنقاط بتصميم جديد
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Team A Score Card
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
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
                    const Icon(Icons.group, color: Colors.cyanAccent, size: 32),
                    const SizedBox(height: 4),
                    const Text(
                      'الفريق 1',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      '$_team1Points',
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
                          onPressed: () => setState(() => _team1Points++),
                          icon: const Icon(Icons.add_circle,
                              color: Colors.greenAccent, size: 26),
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            if (_team1Points > 0) _team1Points--;
                          }),
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.redAccent, size: 26),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Team B Score Card
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
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
                    const Text(
                      'الفريق 2',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      '$_team2Points',
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
                          onPressed: () => setState(() => _team2Points++),
                          icon: const Icon(Icons.add_circle,
                              color: Colors.greenAccent, size: 26),
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            if (_team2Points > 0) _team2Points--;
                          }),
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
          const Divider(color: AppColors.darkBlue, thickness: 1.5, height: 30),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questions.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                final q = _questions[index];
                final answers = (q['answers'] as List).cast<String>();
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    color: AppColors.darkBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    shadowColor: AppColors.glowBlue.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            q['question'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.separated(
                              itemCount: answers.length,
                              separatorBuilder: (_, __) => const Divider(
                                  color: AppColors.secondaryBackground,
                                  height: 8),
                              itemBuilder: (context, i) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  answers[i],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.glowBlue,
                                    fontSize: 18,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            runSpacing: 8,
            children: List.generate(
              _questions.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 12,
                width: _currentPage == i ? 24 : 12,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? AppColors.glowBlue
                      : AppColors.darkBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
