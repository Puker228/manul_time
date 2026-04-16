import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/counter_local_datasource.dart';
import '../../data/repositories/counter_repository_impl.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/counter_state.dart';
import '../../domain/repositories/counter_repository.dart';
import '../../services/audio_service.dart';
import 'achievement_notifier.dart';
import 'counter_notifier.dart';

// ── Data layer providers ───────────────────────────────────────────────────

final counterLocalDatasourceProvider = Provider<CounterLocalDatasource>(
  (_) => CounterLocalDatasource(),
);

final counterRepositoryProvider = Provider<CounterRepository>(
  (ref) => CounterRepositoryImpl(ref.read(counterLocalDatasourceProvider)),
);

// ── Service providers ──────────────────────────────────────────────────────

final audioServiceProvider = Provider<AudioService>(
  (_) => StubAudioService(),
);

// ── Presentation providers ─────────────────────────────────────────────────

/// Exposed as a top-level variable so [CounterNotifier] can reference it.
final achievementNotifierProvider =
    StateNotifierProvider<AchievementNotifier, AchievementState>(
  (_) => AchievementNotifier(),
);

final counterNotifierProvider =
    StateNotifierProvider<CounterNotifier, CounterState>(
  (ref) => CounterNotifier(ref.read(counterRepositoryProvider), ref),
);

// ── Derived / selector providers ──────────────────────────────────────────

/// Exposes only the current count to widgets that don't need full state,
/// preventing unnecessary rebuilds.
final countProvider = Provider<BigInt>(
  (ref) => ref.watch(counterNotifierProvider).count,
);

/// Exposes only the running flag.
final isRunningProvider = Provider<bool>(
  (ref) => ref.watch(counterNotifierProvider).isRunning,
);

/// Exposes only the mode flag.
final isAutoModeProvider = Provider<bool>(
  (ref) => ref.watch(counterNotifierProvider).isAutoMode,
);
