import 'package:flutter/material.dart';

class DraggablePanelTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          constraints: BoxConstraints(maxWidth: 200.0),
          height: 5.0,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
