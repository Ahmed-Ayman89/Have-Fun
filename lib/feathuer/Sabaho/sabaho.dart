import 'package:flutter/material.dart';

import '../../core/utils/App_colors.dart';
import '../../core/widget/cusstom_app_bar.dart';
import '../../core/widget/cusstom_button.dart';
import '../../core/helper/navigation_helper.dart';

import 'screens/ehpd_screen.dart';
import 'screens/fridayGame/view/friday_page.dart';
import 'screens/meen.dart';
import 'screens/offside_screen.dart';
import 'screens/password.dart';
import 'screens/resk.dart';

class Football extends StatelessWidget {
  const Football({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: CustomAppBar(
        title: 'صباحو',
        titleColor: AppColors.pureWhite,
        backgroundColor: AppColors.primaryBackground,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomMenuButton(
                iconColor: AppColors.pureWhite,
                textColor: AppColors.pureWhite,
                buttonColor: AppColors.glowBlue,
                label: 'اسماء لاعبين',
                icon: Icons.person_search,
                onPressed: () {
                  NavigationHelper.navigateWithFade(context, PasworChalleng());
                },
              ),
              const SizedBox(height: 25),
              CustomMenuButton(
                iconColor: AppColors.pureWhite,
                textColor: AppColors.pureWhite,
                buttonColor: AppColors.glowBlue,
                label: 'الكوره واللاين مان',
                icon: Icons.flag,
                onPressed: () {
                  NavigationHelper.navigateWithFade(context, FridayPage());
                },
              ),
              const SizedBox(height: 25),
              CustomMenuButton(
                iconColor: AppColors.pureWhite,
                textColor: AppColors.pureWhite,
                buttonColor: AppColors.glowBlue,
                label: 'اهبد صح',
                icon: Icons.psychology_alt,
                onPressed: () {
                  NavigationHelper.navigateWithFade(context, Ehbedpage());
                },
              ),
              const SizedBox(height: 25),
              CustomMenuButton(
                iconColor: AppColors.pureWhite,
                textColor: AppColors.pureWhite,
                buttonColor: AppColors.glowBlue,
                label: 'مين في الصوره',
                icon: Icons.image_search,
                onPressed: () {
                  NavigationHelper.navigateWithFade(context, MeenPage());
                },
              ),
              const SizedBox(height: 25),
              CustomMenuButton(
                iconColor: AppColors.pureWhite,
                textColor: AppColors.pureWhite,
                buttonColor: AppColors.glowBlue,
                label: 'ريسك',
                icon: Icons.warning_amber_rounded,
                onPressed: () {
                  NavigationHelper.navigateWithFade(context, ReskPage());
                },
              ),
              const SizedBox(height: 25),
              CustomMenuButton(
                iconColor: AppColors.pureWhite,
                textColor: AppColors.pureWhite,
                buttonColor: AppColors.glowBlue,
                label: 'اوفسايد',
                icon: Icons.sports,
                onPressed: () {
                  NavigationHelper.navigateWithFade(context, OffsideScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
