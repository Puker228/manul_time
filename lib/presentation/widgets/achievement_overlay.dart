import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/achievement.dart';
import '../providers/providers.dart';

/// Listens for newly unlocked achievements and displays a slide-in toast
/// at the top of the screen, then auto-dismisses after a short delay.
class AchievementOverlay extends ConsumerStatefulWidget {
  const AchievementOverlay({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AchievementOverlay> createState() => _AchievementOverlayState();
}

class _AchievementOverlayState extends ConsumerState<AchievementOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  Achievement? _displayed;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _show(Achievement achievement) async {
    setState(() => _displayed = achievement);
    await _ctrl.forward(from: 0);
    await Future.delayed(AppConstants.achievementToastDuration);
    if (!mounted) return;
    await _ctrl.reverse();
    if (!mounted) return;
    setState(() => _displayed = null);
    ref.read(achievementNotifierProvider.notifier).dismissNewlyUnlocked();
  }

  @override
  Widget build(BuildContext context) {
    // React to new achievements without rebuilding the whole tree.
    ref.listen(achievementNotifierProvider, (prev, next) {
      final newA = next.newlyUnlocked;
      if (newA != null && newA != prev?.newlyUnlocked && _displayed == null) {
        _show(newA);
      }
    });

    return Stack(
      children: [
        widget.child,
        if (_displayed != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            right: 24,
            child: SlideTransition(
              position: _slideAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: _AchievementCard(achievement: _displayed!),
              ),
            ),
          ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      color: const Color(0xFF1E1E2C),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Text(achievement.icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievement unlocked',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    achievement.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    achievement.description,
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
