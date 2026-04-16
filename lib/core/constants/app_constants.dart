import 'package:flutter/material.dart';
import '../../domain/entities/achievement.dart';

/// Central place for app-wide constants.
/// Change [autoCountInterval] here to adjust the counting speed.
class AppConstants {
  AppConstants._();

  static const String appName = 'ManulTime';

  /// How often the auto-counter ticks.
  static const Duration autoCountInterval = Duration(seconds: 2);

  /// How long an achievement toast is visible.
  static const Duration achievementToastDuration = Duration(seconds: 3);

  /// Formats a [BigInt] with comma separators for display.
  /// e.g. 1234567 → "1,234,567"
  static String formatCount(BigInt n) {
    if (n == BigInt.zero) return '0';
    final str = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  // ── Manul visual variants ────────────────────────────────────────────────
  // Five color palettes cycling as the counter climbs.

  static const List<ManulVariant> manulVariants = [
    ManulVariant(
      name: 'Steppe Grey',
      furColor: Color(0xFF8D8D8D),
      eyeColor: Color(0xFFCDC000),
      bgColor: Color(0xFF1A1A2E),
    ),
    ManulVariant(
      name: 'Tawny Dusk',
      furColor: Color(0xFFB5651D),
      eyeColor: Color(0xFFE8A020),
      bgColor: Color(0xFF1C1209),
    ),
    ManulVariant(
      name: 'Arctic Silver',
      furColor: Color(0xFFB8C4CC),
      eyeColor: Color(0xFF7EC8E3),
      bgColor: Color(0xFF0D1B2A),
    ),
    ManulVariant(
      name: 'Shadow Slate',
      furColor: Color(0xFF546E7A),
      eyeColor: Color(0xFFFFE066),
      bgColor: Color(0xFF0F0F1A),
    ),
    ManulVariant(
      name: 'Sandy Plateau',
      furColor: Color(0xFFD4A257),
      eyeColor: Color(0xFF7DC67E),
      bgColor: Color(0xFF1A1408),
    ),
  ];

  // ── Achievements ─────────────────────────────────────────────────────────

  static final List<Achievement> achievements = [
    Achievement(
      id: 'first_manul',
      title: 'First Manul',
      description: 'A single manul blinks at you.',
      threshold: BigInt.one,
      icon: '🐱',
    ),
    Achievement(
      id: 'the_dozen',
      title: 'The Dozen',
      description: 'A suspiciously round number of manuls.',
      threshold: BigInt.from(12),
      icon: '🎲',
    ),
    Achievement(
      id: 'the_answer',
      title: 'The Answer',
      description: '42 manuls know the answer.',
      threshold: BigInt.from(42),
      icon: '🌌',
    ),
    Achievement(
      id: 'century',
      title: 'Century',
      description: '100 manuls form a fluffy committee.',
      threshold: BigInt.from(100),
      icon: '💯',
    ),
    Achievement(
      id: 'error_404',
      title: 'Error 404',
      description: 'Sleep not found.',
      threshold: BigInt.from(404),
      icon: '🔍',
    ),
    Achievement(
      id: 'millennium',
      title: 'Millennium',
      description: 'A thousand manuls cannot be wrong.',
      threshold: BigInt.from(1000),
      icon: '🏆',
    ),
    Achievement(
      id: 'ten_thousand',
      title: 'Ten Thousand',
      description: 'You are truly devoted.',
      threshold: BigInt.from(10000),
      icon: '⭐',
    ),
    Achievement(
      id: 'million',
      title: 'One Million',
      description: 'The steppe is overrun.',
      threshold: BigInt.from(1000000),
      icon: '🌟',
    ),
  ];
}

/// Defines the visual appearance of one manul variant.
@immutable
class ManulVariant {
  const ManulVariant({
    required this.name,
    required this.furColor,
    required this.eyeColor,
    required this.bgColor,
  });

  final String name;
  final Color furColor;
  final Color eyeColor;
  final Color bgColor;
}
