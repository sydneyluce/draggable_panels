import 'package:draggable_panels/drag_detection_wrapper.dart';
import 'package:draggable_panels/draggable_panel_tab.dart';
import 'package:flutter/material.dart';

enum DraggablePanelPosition { start, end }

class DraggablePanel extends StatelessWidget {
  final double maxDragExtent;
  final Widget child;

  DraggablePanel({this.maxDragExtent = 200.0, this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: child,
    );
  }
}

class DraggablePanelController extends StatefulWidget {
  final Key key;
  final DraggablePanel child;
  final DraggablePanelPosition position;
  final VoidCallback dragStarted;

  DraggablePanelController({this.key, @required this.child, this.position = DraggablePanelPosition.end, this.dragStarted}) : super(key: key);

  @override
  DraggablePanelControllerState createState() => DraggablePanelControllerState();
}

class DraggablePanelControllerState extends State<DraggablePanelController> {
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
            height: _dragExtent.clamp(0, _calculateResponsiveMaxDragExtent()),
            child: widget.child,
          ),
          DragDetectionWrapper(
            onDragStart: _handleDragStart,
            onDragUpdate: _handleDragUpdate,
            onDragEnd: _handleDragEnd,
            child: DraggablePanelTab(),
          ),
        ],
      ),
    );
  }

  void expand() {
    setState(() {
      _dragExtent = _calculateResponsiveMaxDragExtent();
      _expanded = true;
    });
  }

  void collapse() {
    setState(() {
      _dragExtent = 0;
      _expanded = false;
    });
  }

  double _calculateDragExtent(Offset delta) {
    bool inStartPosition = widget.position == DraggablePanelPosition.start;
    bool inEndPosition = widget.position == DraggablePanelPosition.end;
    bool isDraggingUp = delta.dy <= -1.0;
    bool isDraggingDown = delta.dy >= 1.0;

    double incrementBy;

    if (inStartPosition && isDraggingDown || inEndPosition && isDraggingUp)
      incrementBy = delta.distance;
    else if (inStartPosition && isDraggingUp || inEndPosition && isDraggingDown)
      incrementBy = -delta.distance;
    else
      incrementBy = 0;

    return (_dragExtent + incrementBy).clamp(0.0, widget.child.maxDragExtent);
  }

  double _calculateResponsiveMaxDragExtent() {
    double screenHeight = MediaQuery.of(context).size.height - 74;

    return widget.child.maxDragExtent < screenHeight ? widget.child.maxDragExtent : screenHeight;
  }

  double _calculateMinDragExtent() {
    return _expanded ? widget.child.maxDragExtent - 50.0 : 50.0;
  }

  VerticalDirection _determineVerticalDirection() {
    return widget.position == DraggablePanelPosition.end ? VerticalDirection.up : VerticalDirection.down;
  }

  void _handleDragStart(DragStartDetails details) {
    widget.dragStarted();
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragExtent.clamp(_calculateMinDragExtent(), widget.child.maxDragExtent) == _dragExtent) {
      expand();
    } else {
      collapse();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    print(details.delta.distance);
    setState(() {
      _dragExtent = _calculateDragExtent(details.delta);
    });
  }
}
