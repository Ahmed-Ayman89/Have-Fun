import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/data/offside_data.dart';
import '../../../core/utils/App_colors.dart';

class OffsideScreen extends StatefulWidget {
  const OffsideScreen({super.key});

  @override
  State<OffsideScreen> createState() => _OffsideScreenState();
}

class _OffsideScreenState extends State<OffsideScreen> {
  late List<String> _displayedPrompts;
  late PageController _pageController;
  int _currentPageIndex = 0;

  int _team1Score = 0;
  int _team2Score = 0;
  Timer? _timer;
  int _timeInSeconds = 50;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPageIndex = _pageController.page!.round();
        });
      }
    });
    _shufflePrompts();
  }

  void _shufflePrompts() {
    final random = Random();
    final allPrompts = List.from(offsidePrompts);
    allPrompts.shuffle(random);

    setState(() {
      _displayedPrompts = allPrompts.take(10).toList().cast<String>();
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      _currentPageIndex = 0;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeInSeconds > 0) {
        setState(() => _timeInSeconds--);
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
      _timeInSeconds = 90;
      _team1Score = 0;
      _team2Score = 0;
    });
    _shufflePrompts();
  }

  void _addPointToTeam(int teamNumber) {
    setState(() {
      if (teamNumber == 1) {
        _team1Score++;
      } else {
        _team2Score++;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            'اوفسايد',
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
            _buildHeader(),
            const Divider(color: AppColors.darkBlue),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _displayedPrompts.length,
                (index) => _buildPageIndicator(index == _currentPageIndex),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _displayedPrompts.length,
                itemBuilder: (context, index) {
                  final prompt = _displayedPrompts[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildPromptCard(prompt),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _resetGame,
          backgroundColor: AppColors.errorColor,
          icon: const Icon(Icons.refresh, color: AppColors.pureWhite),
          label: const Text(
            'لعبة جديدة',
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeamScore('الفريق 1', _team1Score),
              _buildTimerDisplay(),
              _buildTeamScore('الفريق 2', _team2Score),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton('إيقاف', Icons.pause, _stopTimer),
              _buildControlButton('بدء', Icons.play_arrow, _startTimer),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTeamScore(String teamName, int score) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(teamName,
            style: const TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: 18,
                fontFamily: 'Cairo')),
        Text('$score',
            style: const TextStyle(
                color: AppColors.glowBlue,
                fontSize: 32,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTimerDisplay() {
    final isDanger = _timeInSeconds <= 10;
    return Column(
      children: [
        const Text('الوقت',
            style: TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: 18,
                fontFamily: 'Cairo')),
        Text(
          '${(_timeInSeconds ~/ 60).toString().padLeft(2, '0')}:${(_timeInSeconds % 60).toString().padLeft(2, '0')}',
          style: TextStyle(
              color: isDanger ? AppColors.errorColor : AppColors.pureWhite,
              fontSize: 32,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildControlButton(
      String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkBlue,
          foregroundColor: AppColors.pureWhite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontFamily: 'Cairo')),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 10,
      width: isActive ? 20 : 10,
      decoration: BoxDecoration(
        color: isActive ? AppColors.glowBlue : AppColors.darkBlue,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildPromptCard(String prompt) {
    return Card(
      color: AppColors.darkBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      shadowColor: AppColors.glowBlue.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    prompt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                        height: 1.5,
                        fontFamily: 'Cairo'),
                  ),
                ),
              ),
            ),
            const Divider(color: AppColors.glowBlue, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                      onPressed: () => _addPointToTeam(1),
                      icon:
                          const Icon(Icons.add, color: AppColors.successColor),
                      label: const Text('الفريق 1',
                          style: TextStyle(
                              color: AppColors.primaryTextColor,
                              fontFamily: 'Cairo'))),
                  TextButton.icon(
                      onPressed: () => _addPointToTeam(2),
                      icon:
                          const Icon(Icons.add, color: AppColors.successColor),
                      label: const Text('الفريق 2',
                          style: TextStyle(
                              color: AppColors.primaryTextColor,
                              fontFamily: 'Cairo'))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
