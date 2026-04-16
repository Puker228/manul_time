import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Draws a stylised Pallas's cat face using [CustomPainter] — no image assets
/// required. The variant cycles through [AppConstants.manulVariants] based on
/// the current count, giving a subtle visual change as the counter climbs.
class ManulAvatar extends StatelessWidget {
  const ManulAvatar({
    super.key,
    required this.count,
    this.size = 180,
  });

  final BigInt count;
  final double size;

  @override
  Widget build(BuildContext context) {
    final index = (count % BigInt.from(AppConstants.manulVariants.length))
        .toInt();
    final variant = AppConstants.manulVariants[index];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: SizedBox(
        key: ValueKey(index),
        width: size,
        height: size,
        child: CustomPaint(
          painter: _ManulPainter(
            furColor: variant.furColor,
            eyeColor: variant.eyeColor,
          ),
        ),
      ),
    );
  }
}

class _ManulPainter extends CustomPainter {
  const _ManulPainter({
    required this.furColor,
    required this.eyeColor,
  });

  final Color furColor;
  final Color eyeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.40;

    final furPaint = Paint()..color = furColor;
    final darkFurPaint = Paint()
      ..color = furColor.withValues(alpha: 0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final eyeWhitePaint = Paint()..color = const Color(0xFFEEEEDD);
    final eyeColorPaint = Paint()..color = eyeColor;
    final pupilPaint = Paint()..color = const Color(0xFF111111);
    final nosePaint = Paint()..color = const Color(0xFFE8A0A0);
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final mouthPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // ── Shadow / glow behind the face ────────────────────────────────────
    canvas.drawCircle(Offset(cx, cy + 4), r * 1.05, darkFurPaint);

    // ── Face ─────────────────────────────────────────────────────────────
    canvas.drawCircle(Offset(cx, cy), r, furPaint);

    // Manuls have a subtly flat forehead — paint a slightly flattened arc
    // as a darker cap to reinforce the silhouette.
    final capPaint = Paint()..color = furColor.withValues(alpha: 0.45);
    final capRect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    canvas.drawArc(capRect, -2.8, 5.6, true, capPaint);

    // ── Ears (small, wide-set — characteristic of Pallas's cats) ─────────
    _drawEar(canvas, furPaint, cx - r * 0.60, cy - r * 0.72, -0.4);
    _drawEar(canvas, furPaint, cx + r * 0.60, cy - r * 0.72, 0.4);

    // ── Eyes (large, round, slightly horizontal) ─────────────────────────
    const eyeOffsetX = 0.28;
    const eyeOffsetY = -0.08;
    final eyeR = r * 0.20;

    for (final side in [-1.0, 1.0]) {
      final ex = cx + side * r * eyeOffsetX;
      final ey = cy + r * eyeOffsetY;
      // White sclera
      canvas.drawCircle(Offset(ex, ey), eyeR, eyeWhitePaint);
      // Iris
      canvas.drawCircle(Offset(ex, ey), eyeR * 0.76, eyeColorPaint);
      // Pupil — round (not slit) like a Pallas's cat in bright light
      canvas.drawCircle(Offset(ex, ey), eyeR * 0.38, pupilPaint);
      // Specular highlight
      canvas.drawCircle(
        Offset(ex - eyeR * 0.22, ey - eyeR * 0.22),
        eyeR * 0.18,
        Paint()..color = Colors.white.withValues(alpha: 0.8),
      );
    }

    // ── Nose ─────────────────────────────────────────────────────────────
    final nosePath = Path()
      ..moveTo(cx, cy + r * 0.18)
      ..lineTo(cx - r * 0.10, cy + r * 0.27)
      ..lineTo(cx + r * 0.10, cy + r * 0.27)
      ..close();
    canvas.drawPath(nosePath, nosePaint);

    // ── Mouth — slight grumpy downward curve (signature manul expression) ─
    final mouthPath = Path();
    mouthPath.moveTo(cx - r * 0.18, cy + r * 0.32);
    mouthPath.quadraticBezierTo(cx, cy + r * 0.42, cx + r * 0.18, cy + r * 0.32);
    canvas.drawPath(mouthPath, mouthPaint);

    // ── Whiskers ─────────────────────────────────────────────────────────
    final whiskerY1 = cy + r * 0.20;
    final whiskerY2 = cy + r * 0.28;
    // Left
    canvas.drawLine(Offset(cx - r * 0.15, whiskerY1), Offset(cx - r * 0.85, whiskerY1 - r * 0.06), linePaint);
    canvas.drawLine(Offset(cx - r * 0.15, whiskerY2), Offset(cx - r * 0.85, whiskerY2 + r * 0.06), linePaint);
    // Right
    canvas.drawLine(Offset(cx + r * 0.15, whiskerY1), Offset(cx + r * 0.85, whiskerY1 - r * 0.06), linePaint);
    canvas.drawLine(Offset(cx + r * 0.15, whiskerY2), Offset(cx + r * 0.85, whiskerY2 + r * 0.06), linePaint);

    // ── Forehead stripe markings (manul characteristic) ───────────────────
    final stripesPaint = Paint()
      ..color = furColor.withValues(alpha: 0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx - r * 0.22, cy - r * 0.65), Offset(cx - r * 0.18, cy - r * 0.30), stripesPaint);
    canvas.drawLine(Offset(cx + r * 0.22, cy - r * 0.65), Offset(cx + r * 0.18, cy - r * 0.30), stripesPaint);
  }

  /// Draws a small rounded triangle ear at the given tip position.
  void _drawEar(Canvas canvas, Paint paint, double tipX, double tipY, double lean) {
    final path = Path()
      ..moveTo(tipX, tipY)
      ..lineTo(tipX - 18 + lean * 4, tipY + 26)
      ..lineTo(tipX + 18 + lean * 4, tipY + 26)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ManulPainter old) =>
      furColor != old.furColor || eyeColor != old.eyeColor;
}
