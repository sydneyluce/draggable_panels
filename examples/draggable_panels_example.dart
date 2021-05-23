import 'package:draggable_panels/draggable_panels.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DraggablePanelsExample());
}

class DraggablePanelsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DraggablePanelWrapper(
          startPanel: DraggablePanel(
            maxDragExtent: 500.0,
            position: DraggablePanelPosition.start,
          ),
          endPanel: DraggablePanel(
            maxDragExtent: 500.0,
          ),
          child: Container(),
        ),
      ),
    );
  }
}
