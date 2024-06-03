import 'package:flutter/material.dart';
import 'package:manga_theft/app/theme/color_theme.dart';

class Tags extends StatelessWidget {
  final List<String> tags;

  const Tags({Key? key, required this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.black26,
          endIndent: 5,
          indent: 5,
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: genTagsWidget(
            tags,
            context,
          ),
        ),
      ],
    );
  }

  List<Widget> genTagsWidget(List<String> tags, BuildContext context) {
    var widgets = <Widget>[];
    for (var tag in tags) {
      // widgets.add(
      //   Chip(
      //     backgroundColor: Colors.white,
      //     //elevation: 2,
      //     //padding: EdgeInsets.all(8),
      //     shape: StadiumBorder(
      //       side: BorderSide(
      //         width: 1,
      //         color: Color(0xFF00B6F0),
      //       ),
      //     ),
      //     label: Text(
      //       tag,
      //       style: Theme.of(context).textTheme.caption,
      //     ),
      //   ),
      // );
      widgets.add(
        Container(
          decoration: BoxDecoration(
              color: nearlyWhite,
              border: Border.all(
                color: lightText,
                width: 1,
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
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          child: Text(
            tag,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 9,
                ),
          ),
        ),
      );
    }
    return widgets;
  }
}
