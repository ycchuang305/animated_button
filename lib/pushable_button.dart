import 'package:flutter/material.dart';

class PushableButton extends StatefulWidget {
  const PushableButton({
    Key? key,
    required this.color,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  _PushableButtonState createState() => _PushableButtonState();
}

class _PushableButtonState extends State<PushableButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    );
    _animationController.addStatusListener(_onStatusUpdates);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails tapDownDetails) {
    _animationController.forward();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  void _onStatusUpdates(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(widget.color);
    final hslDark = hsl.withLightness(0.3);
    final shadowColor = hslDark.toColor();
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (_) => _handleTapCancel(),
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          return SizedBox(
            height: 68,
            child: Stack(
              children: [
                Positioned.fill(
                  left: 20,
                  right: 20,
                  top: 8,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: shadowColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Positioned.fill(
                  left: 20,
                  right: 20,
                  top: 0 + (8 * _animationController.value),
                  bottom: 8 - (8 * _animationController.value),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
