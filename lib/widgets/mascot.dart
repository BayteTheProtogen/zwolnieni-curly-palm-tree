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

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  String _getAsciiFace(MascotExpression expression) {
    switch (expression) {
      case MascotExpression.happy:
        return '( ^ ◡ ^ )';
      case MascotExpression.sad:
        return '( u _ u )';
      case MascotExpression.thinking:
        return '( . _ . )';
      case MascotExpression.dancing:
        return '\\( ^ o ^ )/';
      case MascotExpression.sobbing:
        return '( T _ T )';
      case MascotExpression.winning:
        return '*( ^ ∀ ^ )*';
      case MascotExpression.neutral:
        return '( o ◡ - )';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _idleController,
      builder: (context, child) {
        // Organic idle movement: slight bobbing and breathing
        double bobbing = math.sin(_idleController.value * math.pi * 2) * 8;
        double breathing = 1.0 + math.sin(_idleController.value * math.pi * 2) * 0.05;

        return Transform.translate(
          offset: Offset(0, bobbing),
          child: Transform.scale(
            scale: breathing,
            child: Container(
              width: widget.size,
              height: widget.size * 0.8,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(widget.size / 2),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 4,
                ),
              ),
              child: Text(
                _getAsciiFace(widget.expression),
                style: TextStyle(
                  fontSize: widget.size * 0.15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
