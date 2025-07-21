import 'package:flutter/material.dart';
import '../../core/helper/navigation_helper.dart';
import '../../core/utils/App_colors.dart';
import '../../core/widget/cusstom_app_bar.dart';
import '../../core/widget/cusstom_button.dart';
import '../Sabaho/sabaho.dart';
import '../deen/deen_screen.dart';
import '../movie/movie_screen.dart';
import '../random/random_screen.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

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
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Logo with glow
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.25),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/main_logo.jpeg',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    ' score! مرحباً بك في ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomMenuButton(
                    label: 'افلام ومسلسلات مصريه',
                    icon: Icons.movie,
                    buttonColor: AppColors.glowBlue,
                    textColor: AppColors.pureWhite,
                    iconColor: AppColors.pureWhite,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(
                        context,
                        const MovieScreen(),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomMenuButton(
                    label: 'عشوائيات',
                    icon: Icons.shuffle,
                    buttonColor: AppColors.glowBlue,
                    textColor: AppColors.pureWhite,
                    iconColor: AppColors.pureWhite,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(
                        context,
                        const Quizsceen(),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomMenuButton(
                    label: 'صباحو',
                    icon: Icons.sports_soccer,
                    buttonColor: AppColors.glowBlue,
                    textColor: AppColors.pureWhite,
                    iconColor: AppColors.pureWhite,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(
                        context,
                        const Football(),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomMenuButton(
                    label: 'اسئله دينيه',
                    icon: Icons.book,
                    buttonColor: AppColors.glowBlue,
                    textColor: AppColors.pureWhite,
                    iconColor: AppColors.pureWhite,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(
                        context,
                        const DeenPage(),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
