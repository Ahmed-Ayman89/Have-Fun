import 'dart:math';
import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/utils/App_colors.dart';
import '../data/challenge_data.dart';
import '../model/Challenge.dart';
import '../model/board_square.dart';
import '../model/game_modals.dart';
import '../model/player_model.dart';
import '../widget/board_grid_widget.dart';
import '../widget/dice_roll_section.dart';
import '../widget/player_setup_widget.dart';

class FridayPage extends StatefulWidget {
  const FridayPage({super.key});

  @override
  State<FridayPage> createState() => _FridayPageState();
}

class _FridayPageState extends State<FridayPage> {
  final Random _random = Random();

  // حالة لوحة السلم والتعبان
  List<BoardSquare> _board = [];
  String activeDiceImage =
      'assets/images/dice-1.png'; // الصورة المستخدمة لـ DiceRollSection
  int _diceRoll = 1;

  // حالات إعداد اللاعبين ونقاطهم
  bool _showPlayerSetup = true;
  int _numPlayers = 2; // محدود بلاعبين فقط
  List<Player> _players = []; // قائمة كائنات اللاعبين
  int _currentPlayerIndex = 0; // مؤشر اللاعب الذي عليه الدور

  // حالات تحديات الكارت الأصفر
  Challenge?
      _currentDisplayedChallenge; // تحدي السؤال الحالي الذي تم الهبوط عليه (فقط لكروت الأصفار الآن)

  String _gameMessage = ''; // رسائل اللعبة
  String?
      _currentQuestionTextForDisplay; // <--- جديد: لعرض نص السؤال مباشرة على الشاشة

  bool _showIndividualPlayerScoreModal =
      false; // مودال تعديل نقاط اللاعب الفردي (بعد أي سؤال أو من زر AppBar)

  // حالات المؤقت ونقاط الفرق
  int _team1Score = 0;
  int _team2Score = 0;
  Timer? _timer;
  int _timeInSeconds = 90;

  // حالة انتهاء اللعبة والفائز
  bool _gameEnded = false;
  Player? _winner;

  // متحكمات أسماء اللاعبين (تبقى هنا ليتم تمريرها إلى PlayerSetupWidget)
  List<TextEditingController> _playerNameControllers = [];

  @override
  void initState() {
    super.initState();
    // Enforce landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _updatePlayerNameControllers(); // تهيئة متحكمات الأسماء
  }

  // تهيئة متحكمات أسماء اللاعبين (تُستدعى عند تغيير عدد اللاعبين أو عند التهيئة)
  void _updatePlayerNameControllers() {
    // التخلص من المتحكمات القديمة لتجنب تسرب الذاكرة
    for (var controller in _playerNameControllers) {
      controller.dispose();
    }
    _playerNameControllers = List.generate(_numPlayers,
        (index) => TextEditingController(text: 'لاعب ${index + 1}'));
  }

  @override
  void dispose() {
    // Restore orientation to allow all
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // التخلص من جميع المتحكمات والمؤقت عند إغلاق الصفحة
    for (var controller in _playerNameControllers) {
      controller.dispose();
    }
    _timer?.cancel(); // إلغاء المؤقت
    super.dispose();
  }

  // دالة لإنشاء لوحة اللعب
  List<BoardSquare> _generateBoard(List<String> challenges) {
    List<BoardSquare> board = [];
    // Use the fixed boardChallenges list for all squares
    for (int i = 0; i < 30; i++) {
      String question = challenges[i];
      String type = 'normal';
      if ([3, 9, 15, 21, 27].contains(i)) {
        type = 'yellowCard';
      } else if ([6, 12, 18, 24].contains(i)) {
        type = 'redCard';
      }
      board.add(BoardSquare(
        type: type,
        content: question,
        question: question,
        answer: '',
      ));
    }
    return board;
  }

  // دالة لتهيئة اللعبة (عند البدء أو إعادة التشغيل)
  void _initializeGame() {
    setState(() {
      // خلط الأسئلة كل جولة
      List<String> shuffledChallenges = List<String>.from(allChallenges);
      shuffledChallenges.shuffle();
      _board = _generateBoard(shuffledChallenges); // إنشاء لوحة لعب جديدة

      _currentDisplayedChallenge = null; // لا يوجد تحدي معروض في البداية
      _currentQuestionTextForDisplay = null; // إعادة تعيين نص السؤال المعروض

      _team1Score = 0;
      _team2Score = 0;
      _timeInSeconds = 90; // إعادة تعيين الوقت
      _stopTimer(); // إيقاف المؤقت

      _players = List.generate(
          _numPlayers,
          (i) => Player(
                id: 'player-${i + 1}',
                name: _playerNameControllers[i].text.trim().isNotEmpty
                    ? _playerNameControllers[i].text.trim()
                    : 'لاعب ${i + 1}',
                position: 0, // يبدأون من المربع الأول
                score: 0, // نقاط فردية تبدأ من الصفر
                skippedTurns: 0,
                icon: playerIconsData[
                    i % playerIconsData.length], // يتم جلبها من game_data.dart
                color: [
                  Colors.redAccent,
                  Colors.blueAccent,
                  Colors.greenAccent,
                  Colors.purpleAccent,
                ][i % 4],
              ));
      _currentPlayerIndex = 0;
      _showPlayerSetup = false;
      _gameMessage = 'اضغط "Roll" لرمي النرد!'; // رسالة بداية اللعب
      _showIndividualPlayerScoreModal = false;
      _gameEnded = false;
      _winner = null; // إعادة تعيين الفائز
    });
  }

  Future<void> _rollDiceAndMove() async {
    if (_gameEnded) {
      _gameMessage = "اللعبة انتهت! ابدأ لعبة جديدة.";
      return;
    }
    if (_timer == null || !_timer!.isActive) {
      _startTimer();
    }
    Player currentPlayer = _players[_currentPlayerIndex];
    if (currentPlayer.skippedTurns > 0) {
      setState(() {
        _gameMessage = '${currentPlayer.name} تخطى دوره بسبب الكارت الأحمر!';
        _players[_currentPlayerIndex] = currentPlayer.copyWith(
            skippedTurns: currentPlayer.skippedTurns - 1,
            previousPosition: currentPlayer.position);
        _currentQuestionTextForDisplay = null;
      });
      _moveToNextPlayer();
      return;
    }
    final int roll = _random.nextInt(6) + 1;
    setState(() {
      _diceRoll = roll;
      activeDiceImage = 'assets/images/dice-$roll.png';
      _currentQuestionTextForDisplay = null;
    });
    int newPosition = currentPlayer.position + roll;
    if (newPosition >= _board.length) {
      newPosition = _board.length - 1;
    }
    // Save previous position
    _players[_currentPlayerIndex] =
        currentPlayer.copyWith(previousPosition: currentPlayer.position);
    // Move player
    _players[_currentPlayerIndex] = _players[_currentPlayerIndex].copyWith(
        position: newPosition, previousPosition: currentPlayer.position);
    final landedSquare = _board[newPosition];
    // Show dialog for answer
    bool? answeredCorrect = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: landedSquare.type == 'yellowCard'
              ? AppColors.warningColor
              : landedSquare.type == 'redCard'
                  ? AppColors.dangerColor
                  : AppColors.cardBgDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'سؤال (${newPosition + 1})',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.pureWhite,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                landedSquare.question ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: landedSquare.type == 'redCard'
                      ? AppColors.pureWhite
                      : AppColors.primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'عدد الإجابات المطلوبة: $roll',
                style: const TextStyle(
                  color: AppColors.primaryTextColor,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label:
                        const Text('صح', style: TextStyle(fontFamily: 'Cairo')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text('غلط',
                        style: TextStyle(fontFamily: 'Cairo')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dangerColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    // Apply rules based on answer and square type
    if (answeredCorrect == true) {
      if (newPosition == _board.length - 1) {
        setState(() {
          _gameEnded = true;
          _players[_currentPlayerIndex] =
              _players[_currentPlayerIndex].copyWith(position: newPosition);
          _gameMessage =
              '${_players[_currentPlayerIndex].name} وصل إلى النهاية وفاز باللعبة!';
          _winner = _players[_currentPlayerIndex];
        });
        _stopTimer();
        _showGameEndModal();
        return;
      }
      if (landedSquare.type == 'yellowCard') {
        setState(() {
          _gameMessage = 'إجابة صحيحة! العب مرة أخرى.';
        });
        // Play again (do not move to next player)
        return;
      } else if (landedSquare.type == 'redCard') {
        int forward = newPosition + 3;
        if (forward >= _board.length) forward = _board.length - 1;
        _players[_currentPlayerIndex] =
            _players[_currentPlayerIndex].copyWith(position: forward);
        setState(() {
          _gameMessage = 'إجابة صحيحة! تقدمت 3 خانات للأمام.';
        });
      } else {
        setState(() {
          _gameMessage = 'إجابة صحيحة!';
        });
      }
      _moveToNextPlayer();
    } else {
      // Wrong answer
      if (landedSquare.type == 'yellowCard') {
        _players[_currentPlayerIndex] = _players[_currentPlayerIndex]
            .copyWith(skippedTurns: 1, position: currentPlayer.position);
        setState(() {
          _gameMessage = 'إجابة خاطئة! ستحرم من الدور القادم.';
        });
      } else if (landedSquare.type == 'redCard') {
        int backward = newPosition - 3;
        if (backward < 0) backward = 0;
        _players[_currentPlayerIndex] =
            _players[_currentPlayerIndex].copyWith(position: backward);
        setState(() {
          _gameMessage = 'إجابة خاطئة! رجعت 3 خانات للخلف.';
        });
      } else {
        _players[_currentPlayerIndex] = _players[_currentPlayerIndex]
            .copyWith(position: currentPlayer.position);
        setState(() {
          _gameMessage = 'إجابة خاطئة! رجعت للخانة السابقة.';
        });
      }
      _moveToNextPlayer();
    }
  }

  // دالة للانتقال إلى اللاعب التالي
  void _moveToNextPlayer() {
    setState(() {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
      _currentQuestionTextForDisplay =
          null; // إخفاء السؤال عند الانتقال للاعب التالي
    });
  }

  // دالة لتعديل نقاط لاعب فردي (تُستدعى من مودال تعديل نقاط اللاعب)
  void _adjustPlayerScore(String playerId, int points) {
    setState(() {
      _players = _players.map((p) {
        if (p.id == playerId) {
          return p.copyWith(
              score: p.score + points, previousPosition: p.position);
        }
        return p;
      }).toList();
      _updateTeamScores(); // تحديث نقاط الفرق بعد تعديل نقاط اللاعب
      _gameMessage =
          'تم تعديل نقاط اللاعب ${points > 0 ? '+' : ''}$points نقطة.';
    });
  }

  // دالة لتحديث نقاط الفرق بناءً على نقاط اللاعبين الفردية
  void _updateTeamScores() {
    // بما أن هناك لاعبان فقط، كل لاعب يمثل فريق (الفريق 1 هو اللاعب الأول، الفريق 2 هو اللاعب الثاني)
    _team1Score = _players[0].score;
    if (_players.length > 1) {
      _team2Score = _players[1].score;
    } else {
      _team2Score = 0; // في حالة لاعب واحد فقط (لا ينبغي أن يحدث في هذه اللعبة)
    }
  }

  // دالة لفتح مودال تعديل نقاط اللاعب الفردي من زر في AppBar
  void _openIndividualPlayerScoreAdjustment() {
    setState(() {
      _showIndividualPlayerScoreModal = true;
    });
  }

  // دالة لعرض مودال نهاية اللعبة
  void _showGameEndModal() {
    setState(() {
      _showIndividualPlayerScoreModal = false;
      // هذا سيجعل الـ bottomSheet الخاص بنهاية اللعبة يظهر
    });
  }

  // دوال المؤقت
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeInSeconds > 0) {
        setState(() => _timeInSeconds--);
      } else {
        _stopTimer();
        setState(() {
          _gameMessage = "انتهى الوقت! ابدأ لعبة جديدة.";
        });
        _showGameEndModal();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final bool anyModalActive = _showIndividualPlayerScoreModal ||
        (_gameEnded && _winner != null) ||
        (_currentQuestionTextForDisplay != null &&
            !_showIndividualPlayerScoreModal);

    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: _showPlayerSetup
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => setState(() {
                    _showPlayerSetup = true;
                    _stopTimer();
                  }),
                ),
          title: const Text(
            'الكورة و اللاين مان',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          actions: [
            if (!_showPlayerSetup)
              IconButton(
                icon:
                    const Icon(Icons.refresh, size: 28, color: Colors.white70),
                tooltip: 'لعبة جديدة',
                onPressed: _initializeGame,
              ),
            if (!_showPlayerSetup && !anyModalActive)
              IconButton(
                icon: const Icon(Icons.person_add_alt_1,
                    size: 28, color: Colors.white),
                tooltip: 'تعديل نقاط اللاعبين',
                onPressed: _openIndividualPlayerScoreAdjustment,
              ),
          ],
        ),
        body: _showPlayerSetup
            ? PlayerSetupWidget(
                numPlayers: _numPlayers,
                onNumPlayersChanged: (newNum) {
                  setState(() {
                    _numPlayers = newNum;
                    _updatePlayerNameControllers();
                  });
                },
                playerNameControllers: _playerNameControllers,
                onStartGame: _initializeGame,
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            _players.isNotEmpty
                                ? 'الدور على: ${_players[_currentPlayerIndex].name}'
                                : 'جارٍ التهيئة...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 14,
                            runSpacing: 14,
                            alignment: WrapAlignment.center,
                            children: _players
                                .map((p) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 18),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.13),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.10),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              p.icon,
                                              const SizedBox(width: 8),
                                              Text(
                                                '${p.name}: ${p.score} نقطة',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.remove_circle,
                                                    color:
                                                        AppColors.dangerColor,
                                                    size: 26),
                                                onPressed: anyModalActive
                                                    ? null
                                                    : () => _adjustPlayerScore(
                                                        p.id, -1),
                                                tooltip: 'خصم نقطة',
                                                splashRadius: 22,
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.add_circle,
                                                    color:
                                                        AppColors.successColor,
                                                    size: 26),
                                                onPressed: anyModalActive
                                                    ? null
                                                    : () => _adjustPlayerScore(
                                                        p.id, 1),
                                                tooltip: 'إضافة نقطة',
                                                splashRadius: 22,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            _gameMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    BoardGridWidget(
                      board: _board,
                      players: _players,
                      currentPlayerIndex: _currentPlayerIndex,
                    ),
                    const SizedBox(height: 36),
                    if (_currentQuestionTextForDisplay != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          _currentQuestionTextForDisplay!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.warningColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    DiceRollSection(
                      diceRoll: _diceRoll,
                      activeDiceImage: 'assets/images/dice-$_diceRoll.png',
                      onRollDice: _rollDiceAndMove,
                      isDisabled: anyModalActive,
                    ),
                  ],
                ),
              ),

        // مودال تعديل نقاط اللاعب الفردي (يفتح بعد الكارت الأصفر أو من زر AppBar)
        floatingActionButton: _showIndividualPlayerScoreModal
            ? Container(
                color: Colors.black54,
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                child: IndividualPlayerScoreModal(
                  players: _players,
                  onAdjustScore: (playerId, points) {
                    _adjustPlayerScore(
                        playerId, points); // استدعاء دالة التعديل
                  },
                  onClose: () {
                    setState(() {
                      _showIndividualPlayerScoreModal = false;
                      _moveToNextPlayer(); // الانتقال للاعب التالي بعد إغلاق مودال النقاط
                    });
                  },
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        // مودال نهاية اللعبة
        bottomSheet: (_gameEnded && !_showIndividualPlayerScoreModal)
            ? Container(
                color: Colors.black54,
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                child: GameEndModal(
                  team1Score: _team1Score,
                  team2Score: _team2Score,
                  onStartNewGame: () {
                    Navigator.pop(context);
                    _initializeGame();
                  },
                ),
              )
            : null,
      ),
    ));
  }
}
