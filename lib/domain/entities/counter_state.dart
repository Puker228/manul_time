import 'package:flutter/foundation.dart';

/// Domain entity representing the full state of the counter.
/// [BigInt] ensures the counter never overflows, even after millions of years.
@immutable
class CounterState {
  const CounterState({
    required this.count,
    required this.isRunning,
    required this.isAutoMode,
  });

  /// The current manul count.
  final BigInt count;

  /// Whether the auto-timer is currently ticking.
  final bool isRunning;

  /// true  → counter increments automatically every N seconds.
  /// false → only manual increments via the button.
  final bool isAutoMode;

  factory CounterState.initial() => CounterState(
        count: BigInt.zero,
        isRunning: false,
        isAutoMode: true,
      );

  CounterState copyWith({
    BigInt? count,
    bool? isRunning,
    bool? isAutoMode,
  }) {
    return CounterState(
      count: count ?? this.count,
      isRunning: isRunning ?? this.isRunning,
      isAutoMode: isAutoMode ?? this.isAutoMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterState &&
          count == other.count &&
          isRunning == other.isRunning &&
          isAutoMode == other.isAutoMode;

  @override
  int get hashCode => Object.hash(count, isRunning, isAutoMode);
}
