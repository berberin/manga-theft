import 'package:flutter/material.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

class SourceTabChip extends StatelessWidget {
  final String label;
  final bool selected;
  const SourceTabChip({Key key, this.label, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: selected ? nearlyBlue : nearlyWhite,
      label: Text(
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
