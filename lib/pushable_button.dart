import 'package:flutter/material.dart';

class PushableButton extends StatefulWidget {
  const PushableButton({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);
  final Color color;
  final String text;

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
        milliseconds: 750,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(widget.color);
    final hslDark = hsl.withLightness(0.5);
    final shadowColor = hslDark.toColor();
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (_) => _handleTapCancel(),
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          return Container(
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                      color: shadowColor,
                      offset: Offset(
                          0.0, 6.0 * (1.0 - _animationController.value))),
                ]),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
