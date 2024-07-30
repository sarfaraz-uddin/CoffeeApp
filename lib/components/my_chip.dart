import 'package:flutter/material.dart';

/*

MY CHIP

These little chips are for the user to select sizes:
  - small
  - medium
  - large

*/

class MyChip extends StatelessWidget {
  final String text;
  final bool isSelected;

  const MyChip({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return isSelected
        ?
        // display selected chip
        Chip(
            label: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.brown[400],
            padding: const EdgeInsets.all(16),
          )
        :
        // display unselected chip
        Chip(
            label: Text(
              text,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            backgroundColor: Colors.grey[100],
            padding: const EdgeInsets.all(16),
          );
  }
}
