import 'package:draggable_panels/draggable_panels.dart';
import 'package:flutter/material.dart';

class DraggablePanelWrapper extends StatelessWidget {
  final DraggablePanel startPanel;
  final DraggablePanel endPanel;
  final Widget child;

  DraggablePanelWrapper({this.startPanel, this.endPanel, this.child}) {
    if (startPanel != null) assert(startPanel.position == DraggablePanelPosition.start);
    if (endPanel != null) assert(endPanel.position == DraggablePanelPosition.end);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (startPanel != null) startPanel,
        Expanded(
          child: child,
        ),
        if (endPanel != null) endPanel,
      ],
    );
  }
}
