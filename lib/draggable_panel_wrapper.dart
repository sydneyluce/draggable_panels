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
  GlobalKey<DraggablePanelState> _startPanelStateKey;
  GlobalKey<DraggablePanelState> _endPanelStateKey;

  DraggablePanel _startPanel;
  DraggablePanel _endPanel;

  @override
  void initState() {
    _startPanel = _reconstructDraggablePanel(widget.startPanel);
    _endPanel = _reconstructDraggablePanel(widget.endPanel);

    _startPanelStateKey = _startPanel.key;
    _endPanelStateKey = _endPanel.key;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_startPanel != null) _startPanel,
        Expanded(
          child: widget.child,
        ),
        if (_endPanel != null) _endPanel,
      ],
    );
  }

  void _onStartPanelExpanded() {
    if (_endPanelStateKey.currentState.expanded) {
      _endPanelStateKey.currentState.collapse();
    }
  }

  void _onEndPanelExpanded() {
    if (_startPanelStateKey.currentState.expanded) {
      _startPanelStateKey.currentState.collapse();
    }
  }

  DraggablePanel _reconstructDraggablePanel(DraggablePanel draggablePanel) {
    if (draggablePanel == null) return null;

    return DraggablePanel(
      key: draggablePanel.key != null ? draggablePanel.key : new GlobalKey<DraggablePanelState>(),
      maxDragExtent: draggablePanel.maxDragExtent,
      position: draggablePanel.position,
      collapsed: draggablePanel.collapsed,
      expanded: () {
        if (draggablePanel.position == DraggablePanelPosition.end) {
          this._onEndPanelExpanded();
        } else {
          this._onStartPanelExpanded();
        }

        if (draggablePanel.expanded != null) draggablePanel.expanded();
      },
    );
  }
}
