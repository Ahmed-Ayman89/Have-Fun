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
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: CustomAppBar(
          title: 'أفلام ومسلسلات مصرية',
          titleColor: AppColors.pureWhite,
          backgroundColor: AppColors.primaryBackground,
          onTap: () => Navigator.pop(context),
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
            const Divider(color: AppColors.darkBlue, thickness: 1.5),

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
                    backgroundColor: AppColors.glowBlue,
                    foregroundColor: AppColors.pureWhite,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 8,
                  ),
                  onPressed: _getNewMovie,
                  icon: const Icon(Icons.movie_filter_sharp),
                  label: Text(
                    _randomMovie == null ? 'اعرض فيلم' : 'فيلم جديد',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo'),
                  ),
                ),
              ),
            ),
          ],
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
          Icon(Icons.theaters, size: 120, color: AppColors.darkBlue),
          SizedBox(height: 20),
          Text(
            'لعبة تخمين الأفلام والمسلسلات',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor,
                fontFamily: 'Cairo'),
          ),
          SizedBox(height: 10),
          Text(
            'اضغط على "اعرض فيلم" لبدء اللعبة',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: AppColors.secondaryTextColor,
                fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.pureBlack.withOpacity(0.4),
            blurRadius: 15,
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // عرض المعلومات بناءً على مرحلة الكشف
            _buildRevealedContent(movie),

            // عرض زر كشف التلميحات إذا لم تظهر كل المعلومات
            if (_revealStage < 3)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.glowBlue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: _revealNextHint,
                    icon: Icon(
                        _revealStage == 1
                            ? Icons.lightbulb_outline
                            : Icons.image_outlined,
                        color: AppColors.glowBlue),
                    label: Text(
                      _revealStage == 1
                          ? 'أظهر تلميح (السنة والنوع)'
                          : 'اظهر الإجابة (الصورة والاسم)',
                      style: const TextStyle(
                          color: AppColors.glowBlue,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold),
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
    // استخدام AnimatedSwitcher لإضافة تأثيرات عند ظهور كل تلميح
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Column(
        key: ValueKey(_revealStage), // مفتاح ليعرف الويدجت أن المحتوى تغير
        children: [
          // المرحلة الأولى: الوصف
          if (_revealStage >= 1)
            Text(
              '"${movie.description}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryTextColor,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Cairo',
                  height: 1.5),
            ),

          // المرحلة الثانية: السنة والنوع
          if (_revealStage >= 2)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                '(${movie.year}) - (${movie.type})',
                style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.secondaryTextColor,
                    fontFamily: 'Cairo'),
              ),
            ),

          // المرحلة الثالثة: الصورة والاسم
          if (_revealStage >= 3)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  const Divider(color: AppColors.glowBlue),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(movie.image,
                        width: 150, height: 225, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.successColor,
                        fontFamily: 'Cairo'),
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
        Text(
          teamName,
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
              fontFamily: 'Cairo'),
        ),
        Text(
          '$teamScore',
          style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.glowBlue),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => _increaseTeamScore(team),
              icon: const Icon(Icons.add_circle_outline,
                  color: AppColors.successColor),
            ),
            IconButton(
              onPressed: () => _decreaseTeamScore(team),
              icon: const Icon(Icons.remove_circle_outline,
                  color: AppColors.errorColor),
            ),
          ],
        ),
      ],
    );
  }
}
