import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData icon;
  final Color? titleColor;
  final Color? backgroundColor;
  final Color? iconColor;
  const CustomAppBar({
    super.key,
    required this.title,
    this.onTap,
    this.icon = Icons.arrow_back,
    this.titleColor,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
      centerTitle: true,
      leading: onTap == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 40),
                  elevation: 0,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
