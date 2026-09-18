import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AstroAvatar extends StatelessWidget {
  final String? name;
  final double size;
  final IconData? icon;

  const AstroAvatar({super.key, this.name, this.size = 48, this.icon});

  @override
  Widget build(BuildContext context) {
    final initial = name != null && name!.trim().isNotEmpty
        ? name!.trim()[0].toUpperCase()
        : '?';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPink.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: icon != null
          ? Icon(icon, color: Colors.white, size: size * 0.5)
          : Text(
              initial,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}
