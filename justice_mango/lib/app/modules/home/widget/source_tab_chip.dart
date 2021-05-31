import 'package:flutter/material.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

class SourceTabChip extends StatelessWidget {
  final String label;
  final bool selected;
  const SourceTabChip({Key key, this.label, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: selected ? nearlyBlue : nearlyWhite,
          border: Border.all(
            color: lightText,
            width: 1.5,
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1.0,
              offset: Offset(1.0, 1.0),
            ),
          ]),
      padding: EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 15,
      ),
      margin: EdgeInsets.symmetric(
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
