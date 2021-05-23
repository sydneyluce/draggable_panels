import 'package:draggable_panels/drag_detection_wrapper.dart';
import 'package:draggable_panels/draggable_panel_tab.dart';
import 'package:flutter/material.dart';

enum DraggablePanelPosition { start, end }

abstract class DraggablePanel extends StatefulWidget {
  final double maxDragExtent;
  final DraggablePanelPosition position;

  DraggablePanel({this.maxDragExtent, this.position});

  @override
  _DraggablePanelState createState() => _DraggablePanelState();
}

class DraggableStartPanel extends DraggablePanel {
  final double maxDragExtent;

  DraggableStartPanel({this.maxDragExtent = 200.0})
      : super(
          maxDragExtent: maxDragExtent,
          position: DraggablePanelPosition.start,
        );
}

class DraggableEndPanel extends DraggablePanel {
  final double maxDragExtent;

  DraggableEndPanel({this.maxDragExtent = 200.0})
      : super(
          maxDragExtent: maxDragExtent,
          position: DraggablePanelPosition.end,
        );
}

class _DraggablePanelState extends State<DraggablePanel> {
  double _dragExtent = 0.0;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: Column(
        verticalDirection: _determineVerticalDirection(),
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: _dragExtent,
            child: SingleChildScrollView(),
          ),
          DragDetectionWrapper(
            onDragUpdate: _handleDragUpdate,
            onDragEnd: _handleDragEnd,
            child: DraggablePanelTab(),
          )
        ],
      ),
    );
  }

  double _calculateDragExtent(double yPos) {
    bool inStartPosition = widget.position == DraggablePanelPosition.start;
    bool inEndPosition = widget.position == DraggablePanelPosition.end;
    bool isDraggingUp = yPos <= -1.0;
    bool isDraggingDown = yPos >= 1.0;

    double incrementBy;

    if (inStartPosition && isDraggingDown || inEndPosition && isDraggingUp)
      incrementBy = 1.0;
    else if (inStartPosition && isDraggingUp || inEndPosition && isDraggingDown)
      incrementBy = -1.0;
    else
      incrementBy = 0;

    return (_dragExtent + incrementBy).clamp(0.0, widget.maxDragExtent);
  }

  double _calculateMinDragExtent() {
    return _expanded ? widget.maxDragExtent - 50.0 : 50.0;
  }

  VerticalDirection _determineVerticalDirection() {
    return widget.position == DraggablePanelPosition.end ? VerticalDirection.up : VerticalDirection.down;
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      if (_dragExtent.clamp(_calculateMinDragExtent(), widget.maxDragExtent) == _dragExtent) {
        _dragExtent = widget.maxDragExtent;
        _expanded = true;
      } else {
        _dragExtent = 0;
        _expanded = false;
      }
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent = _calculateDragExtent(details.delta.dy);
    });
  }
}
