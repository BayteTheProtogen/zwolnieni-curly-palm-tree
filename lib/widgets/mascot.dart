import 'package:flutter/material.dart';
import 'dart:math' as math;

enum MascotExpression { neutral, happy, sad, thinking, dancing, sobbing, winning }

class CyberMascot extends StatefulWidget {
  final MascotExpression expression;
  final double size;

  const CyberMascot({
    super.key,
    this.expression = MascotExpression.neutral,
    this.size = 200,
  });

  @override
  State<CyberMascot> createState() => _CyberMascotState();
}

class _CyberMascotState extends State<CyberMascot> with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _expressionController;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _expressionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _idleController.dispose();
    _expressionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _idleController,
      builder: (context, child) {
        // Organic idle movement: slight bobbing and breathing
        double bobbing = math.sin(_idleController.value * math.pi * 2) * 5;
        double breathing = 1.0 + math.sin(_idleController.value * math.pi * 2) * 0.03;

        return Transform.translate(
          offset: Offset(0, bobbing),
          child: Transform.scale(
            scale: breathing,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: MascotPainter(
                expression: widget.expression,
                animationValue: _idleController.value,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MascotPainter extends CustomPainter {
  final MascotExpression expression;
  final double animationValue;
  final Color color;

  MascotPainter({
    required this.expression,
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.2;

    // Draw Body (Face)
    // Add slight "squash" based on animation
    double squash = 1.0 + math.sin(animationValue * math.pi * 2) * 0.02;
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2 * (1/squash),
        height: radius * 2 * squash,
      ),
      paint..color = color.withOpacity(0.1),
    );

    // Border
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2 * (1/squash),
        height: radius * 2 * squash,
      ),
      paint..style = PaintingStyle.stroke..strokeWidth = 4..color = color,
    );

    _drawEyes(canvas, center, radius, squash);
    _drawMouth(canvas, center, radius, squash);

    if (expression == MascotExpression.dancing) {
      _drawArms(canvas, center, radius);
    }
  }

  void _drawEyes(Canvas canvas, Offset center, double radius, double squash) {
    final eyePaint = Paint()..color = color..style = PaintingStyle.fill;
    double eyeOffsetX = radius * 0.35;
    double eyeOffsetY = -radius * 0.2 * squash;
    double eyeSize = 6;

    switch (expression) {
      case MascotExpression.happy:
      case MascotExpression.winning:
        // Closed happy eyes ^ ^
        final p1 = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
        canvas.drawPath(Path()..moveTo(center.dx - eyeOffsetX - 10, center.dy + eyeOffsetY + 5)
          ..quadraticBezierTo(center.dx - eyeOffsetX, center.dy + eyeOffsetY - 10, center.dx - eyeOffsetX + 10, center.dy + eyeOffsetY + 5), p1);
        canvas.drawPath(Path()..moveTo(center.dx + eyeOffsetX - 10, center.dy + eyeOffsetY + 5)
          ..quadraticBezierTo(center.dx + eyeOffsetX, center.dy + eyeOffsetY - 10, center.dx + eyeOffsetX + 10, center.dy + eyeOffsetY + 5), p1);
        break;
      case MascotExpression.sad:
      case MascotExpression.sobbing:
        // Sad eyes / \
        canvas.drawCircle(Offset(center.dx - eyeOffsetX, center.dy + eyeOffsetY), eyeSize, eyePaint);
        canvas.drawCircle(Offset(center.dx + eyeOffsetX, center.dy + eyeOffsetY), eyeSize, eyePaint);
        if (expression == MascotExpression.sobbing) {
           // Tears
           final tearPaint = Paint()..color = Colors.blue.withOpacity(0.6);
           double tearPos = (animationValue * 20) % 30;
           canvas.drawCircle(Offset(center.dx - eyeOffsetX, center.dy + eyeOffsetY + 10 + tearPos), 3, tearPaint);
           canvas.drawCircle(Offset(center.dx + eyeOffsetX, center.dy + eyeOffsetY + 10 + tearPos), 3, tearPaint);
        }
        break;
      case MascotExpression.thinking:
        // Dot eyes . .
        canvas.drawCircle(Offset(center.dx - eyeOffsetX, center.dy + eyeOffsetY), eyeSize, eyePaint);
        canvas.drawCircle(Offset(center.dx + eyeOffsetX, center.dy + eyeOffsetY), eyeSize, eyePaint);
        break;
      default:
        // Normal eyes
        double blink = math.sin(animationValue * math.pi * 10) > 0.98 ? 0.1 : 1.0;
        canvas.drawOval(Rect.fromCenter(center: Offset(center.dx - eyeOffsetX, center.dy + eyeOffsetY), width: eyeSize * 2, height: eyeSize * 2 * blink), eyePaint);
        canvas.drawOval(Rect.fromCenter(center: Offset(center.dx + eyeOffsetX, center.dy + eyeOffsetY), width: eyeSize * 2, height: eyeSize * 2 * blink), eyePaint);
    }
  }

  void _drawMouth(Canvas canvas, Offset center, double radius, double squash) {
    final mouthPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    double mouthY = radius * 0.3 * squash;

    switch (expression) {
      case MascotExpression.happy:
      case MascotExpression.winning:
      case MascotExpression.dancing:
        // Smile
        canvas.drawPath(Path()..moveTo(center.dx - 20, center.dy + mouthY)
          ..quadraticBezierTo(center.dx, center.dy + mouthY + 15, center.dx + 20, center.dy + mouthY), mouthPaint);
        break;
      case MascotExpression.sad:
      case MascotExpression.sobbing:
        // Frown
        canvas.drawPath(Path()..moveTo(center.dx - 15, center.dy + mouthY + 5)
          ..quadraticBezierTo(center.dx, center.dy + mouthY - 5, center.dx + 15, center.dy + mouthY + 5), mouthPaint);
        break;
      case MascotExpression.thinking:
        // Flat
        canvas.drawLine(Offset(center.dx - 10, center.dy + mouthY), Offset(center.dx + 10, center.dy + mouthY), mouthPaint);
        break;
      default:
        // Slight smile
        canvas.drawPath(Path()..moveTo(center.dx - 15, center.dy + mouthY)
          ..quadraticBezierTo(center.dx, center.dy + mouthY + 5, center.dx + 15, center.dy + mouthY), mouthPaint);
    }
  }

  void _drawArms(Canvas canvas, Offset center, double radius) {
    final armPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
    double wave = math.sin(animationValue * math.pi * 4) * 20;

    // Left arm
    canvas.drawLine(
      Offset(center.dx - radius - 5, center.dy),
      Offset(center.dx - radius - 25, center.dy - 20 + wave),
      armPaint,
    );
    // Right arm
    canvas.drawLine(
      Offset(center.dx + radius + 5, center.dy),
      Offset(center.dx + radius + 25, center.dy - 20 - wave),
      armPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MascotPainter oldDelegate) {
    return oldDelegate.expression != expression || oldDelegate.animationValue != animationValue;
  }
}
