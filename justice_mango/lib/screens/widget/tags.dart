import 'package:flutter/material.dart';

class Tags extends StatelessWidget {
  final List<String> tags;

  const Tags({Key key, this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Colors.black26,
          endIndent: 5,
          indent: 5,
        ),
        Wrap(
          spacing: 4,
          runSpacing: -10,
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
      widgets.add(Chip(
        backgroundColor: Colors.white,
        elevation: 2,
        //padding: EdgeInsets.all(8),
        shape: StadiumBorder(
          side: BorderSide(
            width: 1,
            color: Color(0xFF00B6F0),
          ),
        ),
        label: Text(
          tag,
          style: Theme.of(context).textTheme.caption,
        ),
      ));
    }
    return widgets;
  }
}
