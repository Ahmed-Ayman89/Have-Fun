import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData icon;
  final Color? titleColor;
  final Color? backgroundColor;
  final Color? iconColor;
  final Widget? leading;
  const CustomAppBar({
    super.key,
    required this.title,
    this.onTap,
    this.icon = Icons.arrow_back,
    this.titleColor,
    this.backgroundColor,
    this.iconColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        centerTitle: true,
        leading: onTap == null ? null : leading);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
