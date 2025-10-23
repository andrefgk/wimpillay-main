import 'package:flutter/material.dart';
import '../utils/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            title,
            style: TextStyles.appBarTitle,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyles.appBarSubtitle,
          ),
        ],
      ),
    );
  }
}