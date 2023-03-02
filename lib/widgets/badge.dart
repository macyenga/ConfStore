// Import the material.dart package which contains the necessary widgets for building UIs in Flutter.
import 'package:flutter/material.dart';

// Define a custom Flutter widget called Badge which extends the StatelessWidget class.
class Badge extends StatelessWidget {
  // Constructor for the Badge widget which requires a child, value, and optional color parameter.
  Badge({
    required this.child, // The widget to display the badge on top of.
    required this.value, // The numerical value to display on the badge.
    this.color, // The color of the badge.
  });

  // The child widget to display the badge on top of.
  final Widget child;

  // The numerical value to display on the badge.
  final String value;

  // The color of the badge. This parameter is optional and can be null.
  Color? color;

  // The build method is required for all stateless widgets in Flutter.
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child, // Display the child widget.
        Positioned(
          right: 3,
          top: 6,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              // Set the color of the badge to either the provided color or the accent color from the current theme.
              color: color != null ? color : Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 14,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
