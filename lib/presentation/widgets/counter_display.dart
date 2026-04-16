import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../providers/providers.dart';

/// Displays "Manul #N" with a smooth scale+fade animation
/// every time the counter changes.
///
/// Uses AnimatedSwitcher with a unique ValueKey so Flutter replaces the
/// old text with the new one through the transition.
class CounterDisplay extends ConsumerWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countProvider);
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.82, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        // ValueKey ensures AnimatedSwitcher detects the change
        key: ValueKey(count),
        'Manul #${AppConstants.formatCount(count)}',
        style: theme.textTheme.displayLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
