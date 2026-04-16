import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

/// Primary controls: Start/Pause, Manual increment, Mode toggle.
/// Each button rebuilds only when its relevant slice of state changes.
class ControlButtons extends ConsumerWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(isRunningProvider);
    final isAutoMode = ref.watch(isAutoModeProvider);
    final notifier = ref.read(counterNotifierProvider.notifier);

    Future<void> confirmReset() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Reset counter?'),
          content: const Text('This will set the manul count back to 0.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Reset'),
            ),
          ],
        ),
      );
      if (confirmed == true) notifier.reset();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Start / Pause  (only shown in Auto mode) ────────────────────
        if (isAutoMode)
          ElevatedButton.icon(
            onPressed: isRunning ? notifier.pause : notifier.start,
            icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
            label: Text(isRunning ? 'Pause' : 'Start'),
          ),

        const SizedBox(height: 16),

        // ── Manual increment ────────────────────────────────────────────
        FilledButton.icon(
          onPressed: notifier.increment,
          icon: const Icon(Icons.add_rounded),
          label: const Text('+1 Manul'),
        ),

        const SizedBox(height: 28),

        // ── Mode toggle ─────────────────────────────────────────────────
        _ModeToggle(
          isAutoMode: isAutoMode,
          onToggle: notifier.toggleMode,
        ),

        const SizedBox(height: 16),

        // ── Reset ────────────────────────────────────────────────────────
        TextButton.icon(
          onPressed: confirmReset,
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Reset'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.redAccent.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.isAutoMode,
    required this.onToggle,
  });

  final bool isAutoMode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAutoMode ? Icons.timer_outlined : Icons.touch_app_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              isAutoMode ? 'AUTO MODE' : 'MANUAL MODE',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
