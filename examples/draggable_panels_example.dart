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
          startPanel: DraggableStartPanel(
            maxDragExtent: 500.0,
          ),
          endPanel: DraggableEndPanel(
            maxDragExtent: 500.0,
          ),
          child: Container(),
        ),
      ),
    );
  }
}
