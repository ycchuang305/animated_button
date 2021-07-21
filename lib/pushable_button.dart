import 'package:flutter/material.dart';

class PushableButton extends StatefulWidget {
  const PushableButton({
    Key? key,
    required this.color,
    required this.height,
    this.elevation = 8.0,
    this.child,
    this.onPressed,
  }) : super(key: key);
  final double height;
  final double elevation;
  final Color color;
  final Widget? child;
  final VoidCallback? onPressed;

  @override
  _PushableButtonState createState() => _PushableButtonState();
}

class _PushableButtonState extends State<PushableButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  bool _isDragInProgress = false;
  Offset _gestureLocation = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails tapDownDetails) {
    _gestureLocation = tapDownDetails.localPosition;
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails tapUpDetails) {
    _animationController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (!_isDragInProgress && mounted) {
        _animationController.reverse();
      }
    });
  }

  void _handleDragStart(DragStartDetails dragStartDetails) {
    _gestureLocation = dragStartDetails.localPosition;
    _isDragInProgress = true;
    _animationController.forward();
  }

  void _handleDragEnd(Size buttonSize) {
    if (_isDragInProgress) {
      _isDragInProgress = false;
      _animationController.reverse();
    }
    if (_gestureLocation.dx >= 0 &&
        _gestureLocation.dx < buttonSize.width &&
        _gestureLocation.dy >= 0 &&
        _gestureLocation.dy < buttonSize.height) {
      widget.onPressed?.call();
    }
  }

  void _handleDragCancel() {
    if (_isDragInProgress) {
      _isDragInProgress = false;
      _animationController.reverse();
    }
  }

  void _handleDragUpdate(DragUpdateDetails dragUpdateDetails) {
    _gestureLocation = dragUpdateDetails.localPosition;
  }

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(widget.color);
    final hslDark = hsl.withLightness(0.3);
    final bottomColor = hslDark.toColor();
    final totalHeight = widget.height + widget.elevation;
    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final buttonSize = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onHorizontalDragStart: _handleDragStart,
            onHorizontalDragEnd: (_) => _handleDragEnd(buttonSize),
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragCancel: _handleDragCancel,
            onVerticalDragStart: _handleDragStart,
            onVerticalDragEnd: (_) => _handleDragEnd(buttonSize),
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragCancel: _handleDragCancel,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) {
                final top = _animationController.value * widget.elevation;
                return Stack(
                  children: [
                    // Draw bottom layer first
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: totalHeight - top,
                        decoration: BoxDecoration(
                          color: bottomColor,
                          borderRadius:
                              BorderRadius.circular(widget.height / 2),
                        ),
                      ),
                    ),
                    // Then top (pushable) layer
                    Positioned(
                      left: 0,
                      right: 0,
                      top: top,
                      child: Container(
                        height: widget.height,
                        decoration: ShapeDecoration(
                            shape: StadiumBorder(), color: widget.color),
                        child: Center(child: widget.child),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
