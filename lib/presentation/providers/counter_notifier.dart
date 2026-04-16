import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/counter_state.dart';
import '../../domain/repositories/counter_repository.dart';
import 'achievement_notifier.dart';
import 'providers.dart';

/// Owns all counter logic: loading, saving, auto-tick, start/pause, increment.
///
/// Receives [Ref] so it can notify the [AchievementNotifier] on each increment
/// without creating a circular dependency.
class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier(this._repository, this._ref)
      : super(CounterState.initial()) {
    _loadSavedCounter();
  }

  final CounterRepository _repository;
  final Ref _ref;
  Timer? _timer;

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> _loadSavedCounter() async {
    final saved = await _repository.loadCounter();
    if (!mounted) return;
    state = state.copyWith(count: saved);
    // Check achievements for the restored count without animating a toast.
    _ref
        .read(achievementNotifierProvider.notifier)
        .silentCheckAchievements(saved);
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Adds one manul, saves, and checks achievements.
  void increment() {
    final next = state.count + BigInt.one;
    state = state.copyWith(count: next);
    _saveCounter(next);
    _ref.read(achievementNotifierProvider.notifier).checkAchievements(next);
  }

  /// Starts the auto-counting timer (only in auto-mode).
  void start() {
    if (state.isRunning || !state.isAutoMode) return;
    state = state.copyWith(isRunning: true);
    _startTimer();
  }

  /// Pauses the auto-counting timer.
  void pause() {
    if (!state.isRunning) return;
    state = state.copyWith(isRunning: false);
    _stopTimer();
  }

  /// Resets the counter to zero, stops the timer, and persists the value.
  void reset() {
    _stopTimer();
    state = state.copyWith(count: BigInt.zero, isRunning: false);
    _saveCounter(BigInt.zero);
  }

  /// Toggles between auto and manual counting modes.
  /// Pauses the timer automatically when switching to manual.
  void toggleMode() {
    final nextAuto = !state.isAutoMode;
    // If switching away from auto while running, stop the timer.
    if (!nextAuto && state.isRunning) {
      _stopTimer();
    }
    state = state.copyWith(isAutoMode: nextAuto, isRunning: false);
  }

  // ── Internals ─────────────────────────────────────────────────────────────

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(AppConstants.autoCountInterval, (_) => increment());
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _saveCounter(BigInt count) {
    // Fire-and-forget; no need to await in the hot path.
    _repository.saveCounter(count);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
