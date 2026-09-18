import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_entrance.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthController _auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _auth.restoring.listen((restoring) {
        if (!restoring) _navigate();
      });
      if (!_auth.restoring.value) {
        Future<void>.delayed(const Duration(milliseconds: 100), _navigate);
      }
    });
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(milliseconds: 1700));
    if (!mounted) return;
    Get.offAllNamed(_auth.isLoggedIn ? AppRoutes.main : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          const _TwinklingStars(),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _brand(),

                  const SizedBox(height: 50),

                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _brand() {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedEntrance(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          beginOffset: const Offset(0, 0.06),
          child: Pulse(
            scale: 1.03,
            duration: const Duration(milliseconds: 2200),
            child: Image.asset('assets/images/logo.png', width: 230),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 350),
          duration: const Duration(milliseconds: 600),
          beginOffset: const Offset(0, 0.03),
          child: Text(
            'Vedic Astrology & Matchmaking',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _TwinklingStars extends StatefulWidget {
  const _TwinklingStars();

  @override
  State<_TwinklingStars> createState() => _TwinklingStarsState();
}

class _TwinklingStarsState extends State<_TwinklingStars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(painter: _StarsPainter(_controller.value));
        },
      ),
    );
  }
}

class _StarsPainter extends CustomPainter {
  final double progress;

  _StarsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.starGold.withValues(alpha: 0.35);
    final random = _seededRandom;
    var index = 0;
    for (final row in [0.12, 0.3, 0.5, 0.68, 0.85]) {
      for (final col in [0.1, 0.35, 0.6, 0.85]) {
        final x = size.width * col;
        final y = size.height * row;
        final twinkle =
            ((progress * 2) % 1 + random[index % random.length]) % 1;
        final radius = 1.2 + 1.6 * twinkle;
        final alpha = 0.2 + 0.3 * twinkle;
        canvas.drawCircle(
          Offset(x, y),
          radius,
          paint..color = AppColors.starGold.withValues(alpha: alpha),
        );
        index++;
      }
    }
  }

  static const _seededRandom = [0.3, 0.8, 0.5, 0.9, 0.2, 0.7, 0.4, 0.6];

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
