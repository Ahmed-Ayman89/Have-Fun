import 'dart:math';
import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
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
    // التخلص من جميع المتحكمات والمؤقت عند إغلاق الصفحة
    for (var controller in _playerNameControllers) {
      controller.dispose();
    }
    _timer?.cancel(); // إلغاء المؤقت
    super.dispose();
  }

  // دالة لإنشاء لوحة اللعب
  List<BoardSquare> _generateBoard() {
    List<BoardSquare> board = [];

    // نجهز قائمة بجميع التحديات (أسئلة وأجوبة) من yellowCardPrompts لـ "الكروت الصفراء فقط"
    List<Challenge> yellowCardChallenges = List.generate(
      yellowCardPrompts.length,
      (index) => Challenge(
        question: yellowCardPrompts[
            index], // الآن yellowCardPrompts هي List<String> مباشرة
        answer: '', // yellowCardAnswers هي List<String> مباشرة
      ),
    )..shuffle(_random);

    int yellowCardChallengeCounter =
        0; // لمتابعة أي تحدي يتم استخدامه لكروت الأصفار
    int allDataContentIndex = 0; // لمتابعة محتوى allData

    // مواقع ثابتة للكروت الخاصة على اللوحة (لضمان وجودها)
    final Set<int> yellowCardPositions = {3, 9, 15}; // 3 كروت صفراء
    final Set<int> redCardPositions = {6, 12, 18}; // 3 كروت حمراء

    for (int i = 0; i < 20; i++) {
      // لوحة من 20 مربعًا (من 0 إلى 19)
      if (redCardPositions.contains(i)) {
        board.add(BoardSquare(type: 'redCard', content: 'كارت أحمر'));
      } else if (yellowCardPositions.contains(i)) {
        // مربع كارت أصفر: له محتوى ثابت وسؤال/إجابة من قائمة تحدياته
        String? question;
        String? answer;

        if (yellowCardChallengeCounter < yellowCardChallenges.length) {
          question = yellowCardChallenges[yellowCardChallengeCounter].question;
          answer = yellowCardChallenges[yellowCardChallengeCounter].answer;
          yellowCardChallengeCounter++;
        } else {
          // Fallback لو نفدت تحديات الكارت الأصفر
          question = 'سؤال عام لكارت أصفر: ما هي عاصمة كذا؟';
          answer = 'القاهرة';
        }

        board.add(BoardSquare(
          type: 'yellowCard',
          content: 'كارت أصفر', // يظل الكونتنت "كارت أصفر"
          question: question,
          answer: answer,
        ));
      } else {
        // مربع عادي: له محتوى من allData، وليس له سؤال/إجابة
        String content;
        if (i == 0) {
          content = 'البداية';
        } else if (i == 19) {
          content = 'النهاية';
        } else {
          // ملء المربعات العادية بمحتوى من allData (اختر قائمة فرعية عشوائية ثم عنصر عشوائي)
          if (allDataContentIndex < allData.length) {
            final randomInnerList = allData[_random.nextInt(allData.length)];
            if (randomInnerList.isNotEmpty) {
              content =
                  randomInnerList[_random.nextInt(randomInnerList.length)];
            } else {
              content = 'مربع عادي'; // Fallback for empty inner lists
            }
            allDataContentIndex++;
          } else {
            content = 'مربع عادي'; // محتوى احتياطي
          }
        }
        // المربعات العادية ليس لها سؤال أو إجابة (question: null, answer: null)
        board.add(BoardSquare(
            type: 'normal', content: content, question: null, answer: null));
      }
    }
    return board;
  }

  // دالة لتهيئة اللعبة (عند البدء أو إعادة التشغيل)
  void _initializeGame() {
    setState(() {
      _board = _generateBoard(); // إنشاء لوحة لعب جديدة

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

  // دالة لرمي النرد وتحريك اللاعب
  void _rollDiceAndMove() {
    if (_gameEnded) {
      _gameMessage = "اللعبة انتهت! ابدأ لعبة جديدة.";
      return;
    }

    if (_timer == null || !_timer!.isActive) {
      _startTimer(); // بدء المؤقت عند أول رمية
    }

    Player currentPlayer = _players[_currentPlayerIndex];

    if (currentPlayer.skippedTurns > 0) {
      setState(() {
        _gameMessage = '${currentPlayer.name} تخطى دوره بسبب الكارت الأحمر!';
        _players[_currentPlayerIndex] = currentPlayer.copyWith(
            skippedTurns: currentPlayer.skippedTurns - 1);
        _currentQuestionTextForDisplay = null; // إخفاء السؤال إن كان معروضًا
      });
      _moveToNextPlayer();
      return;
    }

    final int roll = _random.nextInt(6) + 1;
    setState(() {
      _diceRoll = roll;
      activeDiceImage = 'assets/images/dice-$roll.png'; // تحديث صورة النرد
      _currentQuestionTextForDisplay =
          null; // إخفاء السؤال السابق عند رمي النرد
    });

    int newPosition = currentPlayer.position + roll;

    if (newPosition >= _board.length - 1) {
      newPosition = _board.length - 1;
      setState(() {
        _gameEnded = true;
        _players[_currentPlayerIndex] =
            currentPlayer.copyWith(position: newPosition);
        _gameMessage =
            '${_players[_currentPlayerIndex].name} وصل إلى النهاية وفاز باللعبة!';
        _winner = _players[_currentPlayerIndex]; // تعيين الفائز
      });
      _stopTimer(); // إيقاف المؤقت عند انتهاء اللعبة
      _showGameEndModal(); // عرض مودال نهاية اللعبة
      return;
    } else {
      setState(() {
        _gameMessage =
            '${currentPlayer.name} رمى $roll وتحرك إلى مربع ${newPosition + 1}.';
        _players[_currentPlayerIndex] =
            currentPlayer.copyWith(position: newPosition);
      });
    }

    final landedSquare = _board[newPosition];
    if (landedSquare.type == 'redCard') {
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _gameMessage =
              '${currentPlayer.name} هبط على كارت أحمر! سيخسر دوره القادم.';
          _players[_currentPlayerIndex] =
              currentPlayer.copyWith(skippedTurns: 1);
        });
        _moveToNextPlayer();
      });
    } else if (landedSquare.type == 'yellowCard' &&
        landedSquare.question != null) {
      // <--- مربع "كارت أصفر"
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _currentDisplayedChallenge = Challenge(
            // قم بإنشاء تحدي من بيانات المربع
            question: landedSquare.question!,
            answer: '', // الإجابة ستكون null هنا
          );

          _currentQuestionTextForDisplay =
              _currentDisplayedChallenge!.question; // عرض السؤال
          _gameMessage =
              'تحدي لكارت أصفر لـ ${_players[_currentPlayerIndex].name}:'; // تحديث رسالة اللعبة
          _showIndividualPlayerScoreModal =
              true; // فتح مودال تعديل النقاط الفردي مباشرة
        });
      });
    } else if (landedSquare.type == 'normal' && landedSquare.question != null) {
      // <--- مربع عادي بسؤال
      setState(() {
        _currentDisplayedChallenge = Challenge(
          // قم بإنشاء تحدي من بيانات المربع
          question: landedSquare.question!,
          answer: '', // الإجابة ستكون null هنا
        );
        _currentQuestionTextForDisplay =
            _currentDisplayedChallenge!.question; // عرض السؤال
        _gameMessage =
            'سؤال لـ ${_players[_currentPlayerIndex].name}:'; // تحديث رسالة اللعبة
      });
      // بعد عرض السؤال، انتظر 3 ثوانٍ ثم انتقل للاعب التالي وأخفِ السؤال
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _currentQuestionTextForDisplay = null; // إخفاء السؤال
          _gameMessage = ''; // مسح الرسالة المرتبطة بالسؤال
          _moveToNextPlayer(); // الانتقال للاعب التالي
        });
      });
    } else {
      // انتقال عادي إذا لم يكن كارت أحمر ولا أصفر بسؤال ولا عادي بسؤال
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
          return p.copyWith(score: p.score + points);
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
    // تحديد ما إذا كان أي مودال نشطًا لتعطيل تفاعل المحتوى الرئيسي
    final bool anyModalActive = _showIndividualPlayerScoreModal ||
        (_gameEnded && _winner != null) ||
        (_currentQuestionTextForDisplay != null &&
            !_showIndividualPlayerScoreModal);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackground,
          elevation: 0,
          leading: _showPlayerSetup
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.primaryTextColor),
                  onPressed: () => setState(() {
                    _showPlayerSetup = true;
                    _stopTimer(); // إيقاف المؤقت عند العودة لشاشة الإعداد
                  }),
                ),
          title: const Text(
            'الكورة و اللاين مان',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: true,
          actions: [
            if (!_showPlayerSetup)
              IconButton(
                icon: const Icon(Icons.refresh,
                    size: 28, color: AppColors.glowBlue),
                tooltip: 'لعبة جديدة',
                onPressed: _initializeGame,
              ),
            if (!_showPlayerSetup && !anyModalActive)
              IconButton(
                icon: const Icon(Icons.person_add_alt_1,
                    size: 28, color: AppColors.pureWhite),
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
                    _updatePlayerNameControllers(); // تحديث المتحكمات هنا
                  });
                },
                playerNameControllers: _playerNameControllers,
                onStartGame: _initializeGame,
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
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
                              color: AppColors.pureWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: _players
                                .map((p) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.cardBgLight,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        // استخدم Column لعرض الاسم والنقاط والأزرار عموديًا
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            // الصف الأيقونة والاسم والنقاط
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              p.icon, // عرض الأيقونة (الصورة)
                                              const SizedBox(width: 8),
                                              Text(
                                                '${p.name}: ${p.score} نقطة', // عرض نقاط اللاعب الفردية
                                                style: const TextStyle(
                                                  color: AppColors
                                                      .primaryTextColor,
                                                  fontSize: 16,
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height:
                                                  4), // مسافة بين النص والأزرار
                                          Row(
                                            // أزرار الزيادة والنقصان
                                            mainAxisSize: MainAxisSize
                                                .min, // Changed to min
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.remove_circle,
                                                    color:
                                                        AppColors.dangerColor,
                                                    size: 24),
                                                onPressed: anyModalActive
                                                    ? null
                                                    : () => _adjustPlayerScore(
                                                        p.id, -1),
                                                tooltip: 'خصم نقطة',
                                                splashRadius: 20,
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.add_circle,
                                                    color:
                                                        AppColors.successColor,
                                                    size: 24),
                                                onPressed: anyModalActive
                                                    ? null
                                                    : () => _adjustPlayerScore(
                                                        p.id, 1),
                                                tooltip: 'إضافة نقطة',
                                                splashRadius: 20,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            _gameMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.primaryTextColor,
                              fontSize: 18,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),

                    BoardGridWidget(
                      // لوحة اللعب الشبكية
                      board: _board,
                      players: _players,
                      currentPlayerIndex: _currentPlayerIndex,
                    ),
                    const SizedBox(height: 30),

                    // <--- عرض السؤال هنا إذا كان موجودًا
                    if (_currentQuestionTextForDisplay != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          _currentQuestionTextForDisplay!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.warningColor, // لون مميز للسؤال
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    // نهاية الجزء الجديد لعرض السؤال

                    DiceRollSection(
                      // قسم النرد
                      diceRoll: _diceRoll,
                      activeDiceImage:
                          'assets/images/dice-$_diceRoll.png', // استخدام الصورة هنا
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
    );
  }
}
