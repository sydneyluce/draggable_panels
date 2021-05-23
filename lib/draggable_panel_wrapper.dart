import 'package:draggable_panels/draggable_panels.dart';
import 'package:flutter/material.dart';

class DraggablePanelWrapper extends StatelessWidget {
  final DraggableStartPanel startPanel;
  final DraggableEndPanel endPanel;
  final Widget child;

  DraggablePanelWrapper({this.startPanel, this.endPanel, this.child});

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
