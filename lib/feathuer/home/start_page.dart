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
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: CustomAppBar(
          title: 'سلي نفسك',
          titleColor: AppColors.pureWhite,
          backgroundColor: AppColors.primaryBackground,
          iconColor: AppColors.primaryTextColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
