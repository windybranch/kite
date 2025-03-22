import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = Colors.black,
    this.backgroundColor = Colors.grey,
  });

  /// The icon to be displayed inside the button.
  final IconData icon;

  /// The color of the icon.
  final Color color;

  /// The color of the circular background behind the icon.
  final Color backgroundColor;

  /// The action when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.only(top: 2),
        iconSize: 18,
        icon: Icon(
          icon,
          color: color,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
