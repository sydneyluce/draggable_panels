import 'package:draggable_panels/drag_detection_wrapper.dart';
import 'package:draggable_panels/draggable_panel_tab.dart';
import 'package:flutter/material.dart';

enum DraggablePanelPosition { start, end }

class DraggablePanel extends StatefulWidget {
  final Key key;
  final double maxDragExtent;
  final DraggablePanelPosition position;
  final VoidCallback collapsed;
  final VoidCallback expanded;

  DraggablePanel({this.key, this.maxDragExtent = 200.0, this.position = DraggablePanelPosition.end, this.collapsed, this.expanded}) : super(key: key);

  @override
  DraggablePanelState createState() => DraggablePanelState();
}

class DraggablePanelState extends State<DraggablePanel> {
  double _dragExtent = 0.0;
  bool _expanded = false;

  double get dragExtent => _dragExtent;
  bool get expanded => _expanded;

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

  void expand() {
    setState(() {
      _dragExtent = widget.maxDragExtent;
      _expanded = true;
    });

    if (widget.expanded != null) {
      widget.expanded();
    }
  }

  void collapse() {
    setState(() {
      _dragExtent = 0.0;
      _expanded = false;
    });

    if (widget.collapsed != null) {
      widget.collapsed();
    }
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
    if (_dragExtent.clamp(_calculateMinDragExtent(), widget.maxDragExtent) == _dragExtent) {
      expand();
    } else {
      collapse();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent = _calculateDragExtent(details.delta.dy);
    });
  }
}
