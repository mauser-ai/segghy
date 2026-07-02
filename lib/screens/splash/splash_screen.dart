import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/atmospheric_background.dart';
import '../../providers/game_provider.dart';

/// Prima schermata mostrata all'avvio: titolo del gioco con un breve
/// caricamento atmosferico, poi transizione automatica al menu principale.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final provider = context.read<GameProvider>();
    await provider.init();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    context.go('/menu');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AtmosphericBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.water_drop_outlined,
                  size: 56,
                  color: AppColors.accentGold,
                ),
                const SizedBox(height: 20),
                Text(
                  'SEGGHY',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        letterSpacing: 6,
                      ),
                ),
                Text(
                  'e il Silenzio del Ticino',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 40),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
