import 'package:flutter/foundation.dart';

/// A single achievement milestone.
@immutable
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.threshold,
    required this.icon,
  });

  /// Unique stable identifier used to persist unlock status.
  final String id;
  final String title;
  final String description;

  /// The manul count at which this achievement unlocks.
  final BigInt threshold;

  /// Emoji icon shown in toasts and the (future) achievement screen.
  final String icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Achievement && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Holds the set of unlocked achievement IDs and the most recently
/// unlocked achievement (used to drive the toast notification).
@immutable
class AchievementState {
  const AchievementState({
    required this.unlockedIds,
    this.newlyUnlocked,
  });

  final Set<String> unlockedIds;

  /// Non-null for one frame cycle after an achievement is earned.
  /// The UI listens for this and shows the toast, then calls [clearNew].
  final Achievement? newlyUnlocked;

  factory AchievementState.initial() =>
      const AchievementState(unlockedIds: {});

  AchievementState copyWith({
    Set<String>? unlockedIds,
    Achievement? newlyUnlocked,
    bool clearNew = false,
  }) {
    return AchievementState(
      unlockedIds: unlockedIds ?? this.unlockedIds,
      newlyUnlocked: clearNew ? null : (newlyUnlocked ?? this.newlyUnlocked),
    );
  }

  bool isUnlocked(String id) => unlockedIds.contains(id);
}
