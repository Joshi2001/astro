import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'animated_entrance.dart';

class ScoreRing extends StatelessWidget {
  final double score;
  final double size;
  final double strokeWidth;
  final String? label;

  const ScoreRing({
    super.key,
    required this.score,
    this.size = 96,
    this.strokeWidth = 10,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = score.clamp(0.0, 100.0).toDouble();
    final color = _scoreColor(clamped);
    return AnimatedProgress(
      progress: clamped / 100,
      builder: (context, value, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.brandOrange.withValues(
                    alpha: 0.12,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(value * 100).round()}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.night,
                      fontSize: size * 0.24,
                    ),
                  ),
                  if (label != null)
                    Text(
                      label!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Color _scoreColor(double score) {
    if (score >= 75) return AppColors.success;
    if (score >= 50) return AppColors.brandOrange;
    if (score >= 35) return const Color(0xFFF2A33C);
    return AppColors.brandRed;
  }
}
