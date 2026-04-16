import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../providers/providers.dart';
import '../widgets/achievement_overlay.dart';
import '../widgets/control_buttons.dart';
import '../widgets/counter_display.dart';
import '../widgets/manul_avatar.dart';

/// The one and only screen.
/// Layout is intentionally minimal — a centered column with breathing room.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countProvider);

    // Drive the background colour from the current manul variant for a
    // subtle ambient shift without any layout rebuilds.
    final variantIndex =
        (count % BigInt.from(AppConstants.manulVariants.length)).toInt();
    final bgColor = AppConstants.manulVariants[variantIndex].bgColor;

    return AchievementOverlay(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        color: bgColor,
        child: Scaffold(
          // Transparent so AnimatedContainer background shows through.
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App title
                    Text(
                      AppConstants.appName.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            letterSpacing: 5,
                          ),
                    ),

                    const SizedBox(height: 40),

                    // Manul illustration — changes variant every 5 counts.
                    ManulAvatar(count: count, size: 180),

                    const SizedBox(height: 36),

                    // "Manul #1,234" with entrance animation on each tick.
                    const CounterDisplay(),

                    const SizedBox(height: 48),

                    // Start/Pause · +1 · Mode toggle
                    const ControlButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
