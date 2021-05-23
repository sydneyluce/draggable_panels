import 'package:flutter/material.dart';

class DragDetectionWrapper extends StatelessWidget {
  final Axis direction;
  final Widget child;
  final void Function(DragStartDetails details) onDragStart;
  final void Function(DragEndDetails details) onDragEnd;
  final void Function(DragUpdateDetails details) onDragUpdate;

  DragDetectionWrapper({
    this.direction = Axis.vertical,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (this.direction == Axis.horizontal) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: onDragStart,
        onHorizontalDragEnd: onDragEnd,
        onHorizontalDragUpdate: onDragUpdate,
        child: child,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: onDragStart,
      onVerticalDragEnd: onDragEnd,
      onVerticalDragUpdate: onDragUpdate,
      child: child,
    );
  }
}
