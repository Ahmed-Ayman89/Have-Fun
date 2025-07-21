import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/data/dummy_data.dart';
import '../../core/utils/App_colors.dart';
import '../../core/widget/cusstom_app_bar.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  MovieModel? _randomMovie;
  int _teamAScore = 0;
  int _teamBScore = 0;
  // لتتبع مراحل كشف التلميحات
  int _revealStage = 0;

  // دالة لبدء جولة جديدة بفيلم جديد
  void _getNewMovie() {
    final random = Random();
    setState(() {
      _randomMovie = moviesAndSeries[random.nextInt(moviesAndSeries.length)];
      // عرض أول تلميح (الوصف) مباشرة
      _revealStage = 1;
    });
  }

  // دالة لكشف التلميح التالي
  void _revealNextHint() {
    // نزيد مرحلة الكشف حتى نصل للمرحلة الأخيرة
    if (_revealStage < 3) {
      setState(() {
        _revealStage++;
      });
    }
  }

  void _increaseTeamScore(String team) {
    setState(() {
      if (team == 'A') {
        _teamAScore++;
      } else if (team == 'B') {
        _teamBScore++;
      }
    });
  }

  void _decreaseTeamScore(String team) {
    setState(() {
      if (team == 'A' && _teamAScore > 0) {
        _teamAScore--;
      } else if (team == 'B' && _teamBScore > 0) {
        _teamBScore--;
      }
    });
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
          appBar: CustomAppBar(
            title: 'أفلام ومسلسلات مصرية',
            titleColor: Colors.white,
            backgroundColor: Colors.transparent,
            onTap: () => Navigator.pop(context),
            iconColor: Colors.white,
          ),
          body: Column(
            children: [
              // الجزء العلوي: عرض النقاط
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTeamScoreColumn('الفريق 1', _teamAScore, 'A'),
                    _buildTeamScoreColumn('الفريق 2', _teamBScore, 'B'),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, thickness: 1.5),
              // الجزء الرئيسي: عرض البطاقة أو الواجهة الابتدائية
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _randomMovie == null
                      ? _buildInitialView()
                      : _buildMovieCard(_randomMovie!),
                ),
              ),
              // الزر الرئيسي لبدء جولة جديدة
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      backgroundColor: null,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 12,
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) => null),
                    ),
                    onPressed: _getNewMovie,
                    icon: const Icon(Icons.movie_filter_sharp, size: 28),
                    label: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF36D1C4), Color(0xFF5B86E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(minWidth: 88, minHeight: 36),
                        child: Text(
                          _randomMovie == null ? 'اعرض فيلم' : 'فيلم جديد',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black38,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ]),
                        ),
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
  }

  // --- Widgets البناء ---

  Widget _buildInitialView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.theaters, size: 120, color: Colors.white70, shadows: [Shadow(color: Colors.black45, blurRadius: 12)]),
          SizedBox(height: 20),
          Text(
            'لعبة تخمين الأفلام والمسلسلات',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
                shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2))]),
          ),
          SizedBox(height: 10),
          Text(
            'اضغط على "اعرض فيلم" لبدء اللعبة',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
                fontFamily: 'Cairo',
                shadows: [Shadow(color: Colors.black38, blurRadius: 6)]),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF232526), Color(0xFF2c5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.32),
            blurRadius: 22,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildRevealedContent(movie),
            if (_revealStage < 3)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF36D1C4)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        backgroundColor: Colors.transparent,
                        elevation: 0),
                    onPressed: _revealNextHint,
                    icon: Icon(
                        _revealStage == 1
                            ? Icons.lightbulb_outline
                            : Icons.image_outlined,
                        color: Color(0xFF36D1C4)),
                    label: Text(
                      _revealStage == 1
                          ? 'أظهر تلميح (السنة والنوع)'
                          : 'اظهر الإجابة (الصورة والاسم)',
                      style: const TextStyle(
                          color: Color(0xFF36D1C4),
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          shadows: [Shadow(color: Colors.black26, blurRadius: 4)]),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevealedContent(MovieModel movie) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Column(
        key: ValueKey(_revealStage),
        children: [
          if (_revealStage >= 1)
            Text(
              '"${movie.description}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Cairo',
                  height: 1.5,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 8)]),
            ),
          if (_revealStage >= 2)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                '(${movie.year}) - (${movie.type})',
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontFamily: 'Cairo',
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)]),
              ),
            ),
          if (_revealStage >= 3)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  const Divider(color: Color(0xFF36D1C4)),
                  const SizedBox(height: 20),
                  Container(
                    width: 160,
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.25),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(movie.image,
                          width: 160, height: 240, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF36D1C4),
                        fontFamily: 'Cairo',
                        shadows: [Shadow(color: Colors.black54, blurRadius: 8)]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Column _buildTeamScoreColumn(String teamName, int teamScore, String team) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              team == 'A' ? Icons.sports_esports : Icons.sports_soccer,
              color: team == 'A' ? Color(0xFF36D1C4) : Color(0xFF5B86E5),
              size: 28,
              shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
            ),
            const SizedBox(width: 6),
            Text(
              teamName,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  shadows: [Shadow(color: Colors.black38, blurRadius: 6)]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: team == 'A' ? Color(0xFF36D1C4).withOpacity(0.18) : Color(0xFF5B86E5).withOpacity(0.18),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            '$teamScore',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: team == 'A' ? Color(0xFF36D1C4) : Color(0xFF5B86E5),
                fontFamily: 'Cairo',
                shadows: [Shadow(color: Colors.black26, blurRadius: 4)]),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => _increaseTeamScore(team),
              icon: const Icon(Icons.add_circle_outline, color: Colors.greenAccent, size: 28),
              splashRadius: 22,
            ),
            IconButton(
              onPressed: () => _decreaseTeamScore(team),
              icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 28),
              splashRadius: 22,
            ),
          ],
        ),
      ],
    );
  }
}
