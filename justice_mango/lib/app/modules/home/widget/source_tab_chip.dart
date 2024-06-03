import 'package:flutter/material.dart';
import 'package:manga_theft/app/theme/color_theme.dart';

class SourceTabChip extends StatelessWidget {
  final String label;
  final bool selected;

  const SourceTabChip({Key? key, required this.label, required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: selected ? nearlyBlue : nearlyWhite,
          border: Border.all(
            color: lightText,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1.0,
              offset: Offset(1.0, 1.0),
            ),
          ]),
      padding: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 15,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.27,
          color: selected ? nearlyWhite : nearlyBlue,
        ),
      ),
    );
  }
}
