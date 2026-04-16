import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/achievement.dart';

/// Tracks which achievements have been earned and surfaces new ones to the UI.
class AchievementNotifier extends StateNotifier<AchievementState> {
  AchievementNotifier() : super(AchievementState.initial());

  /// Checks milestones and fires a toast for any newly reached achievement.
  void checkAchievements(BigInt count) {
    for (final a in AppConstants.achievements) {
      if (!state.unlockedIds.contains(a.id) && count >= a.threshold) {
        final updated = {...state.unlockedIds, a.id};
        state = state.copyWith(unlockedIds: updated, newlyUnlocked: a);
        // Only surface one achievement toast at a time; subsequent ones will
        // be picked up on the next call.
        return;
      }
    }
  }

  /// Same as [checkAchievements] but does not set [newlyUnlocked], so no
  /// toast is shown. Used when restoring a saved counter on app start.
  void silentCheckAchievements(BigInt count) {
    final toUnlock = AppConstants.achievements
        .where((a) =>
            !state.unlockedIds.contains(a.id) && count >= a.threshold)
        .map((a) => a.id)
        .toSet();

    if (toUnlock.isEmpty) return;
    state = state.copyWith(
      unlockedIds: {...state.unlockedIds, ...toUnlock},
      clearNew: true,
    );
  }

  /// Called by the UI after the toast has been displayed.
  void dismissNewlyUnlocked() {
    state = state.copyWith(clearNew: true);
  }
}
