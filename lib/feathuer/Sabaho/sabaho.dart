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
import 'screens/top10_screen.dart';

class Football extends StatelessWidget {
  const Football({super.key});

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
            title: 'صباحو',
            titleColor: Colors.white,
            backgroundColor: Colors.transparent,
            iconColor: Colors.white,
          ),
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
                    'ألعاب صباحو الكروية',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomMenuButton(
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    buttonColor: AppColors.glowBlue,
                    label: 'اسماء لاعبين',
                    icon: Icons.person_search,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(context, PasworChalleng());
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomMenuButton(
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    buttonColor: AppColors.glowBlue,
                    label: 'الكوره واللاين مان',
                    icon: Icons.flag,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(context, FridayPage());
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomMenuButton(
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    buttonColor: AppColors.glowBlue,
                    label: 'اهبد صح',
                    icon: Icons.psychology_alt,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(context, Ehbedpage());
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomMenuButton(
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    buttonColor: AppColors.glowBlue,
                    label: 'مين في الصوره',
                    icon: Icons.image_search,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(context, MeenPage());
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomMenuButton(
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    buttonColor: AppColors.glowBlue,
                    label: 'ريسك',
                    icon: Icons.warning_amber_rounded,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(context, ReskPage());
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomMenuButton(
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    buttonColor: AppColors.glowBlue,
                    label: 'اوفسايد',
                    icon: Icons.sports,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(context, OffsideScreen());
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomMenuButton(
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    buttonColor: AppColors.glowBlue,
                    label: 'توب 10',
                    icon: Icons.star,
                    onPressed: () {
                      NavigationHelper.navigateWithFade(context, Top10Screen());
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
