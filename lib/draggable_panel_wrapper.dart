import 'package:draggable_panels/draggable_panels.dart';
import 'package:flutter/material.dart';

class DraggablePanelWrapper extends StatefulWidget {
  final Widget child;

  final DraggablePanel startPanel;
  final DraggablePanel endPanel;

  DraggablePanelWrapper({this.startPanel, this.endPanel, this.child});

  @override
  _DraggablePanelWrapperState createState() => _DraggablePanelWrapperState();
}

class _DraggablePanelWrapperState extends State<DraggablePanelWrapper> {
  final GlobalKey<DraggablePanelControllerState> _startPanelController = new GlobalKey();
  final GlobalKey<DraggablePanelControllerState> _endPanelController = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.startPanel != null) _buildStartDraggablePanelController(),
        Expanded(child: widget.child),
        if (widget.endPanel != null) _buildEndDraggablePanelController(),
      ],
    );
  }

  DraggablePanelController _buildStartDraggablePanelController() {
    return DraggablePanelController(
      key: _startPanelController,
      child: widget.startPanel,
      position: DraggablePanelPosition.start,
      dragStarted: () {
        if (_endPanelController.currentState.expanded) _endPanelController.currentState.collapse();
      },
    );
  }

  DraggablePanelController _buildEndDraggablePanelController() {
    return DraggablePanelController(
      key: _endPanelController,
      child: widget.endPanel,
      dragStarted: () {
        if (_startPanelController.currentState.expanded) _startPanelController.currentState.collapse();
      },
    );
  }
}
