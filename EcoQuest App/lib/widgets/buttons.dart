import 'package:flutter/material.dart';

class CenteredElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final double? width;

  CenteredElevatedButton(this.onPressed, this.label, [this.width]);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: Size(width ?? 0, 40),
          ),
          onPressed: onPressed,
          child: Text(label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
