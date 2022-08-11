import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imhotep/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HotepReadMoreText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? showMoreTextStyle;
  final int limit;
  final double? height;
  const HotepReadMoreText(
    this.text, {
    Key? key,
    this.style,
    this.limit = 100,
    this.showMoreTextStyle,
    this.height,
  }) : super(key: key);

  @override
  State<HotepReadMoreText> createState() => _HotepReadMoreTextState();
}

class _HotepReadMoreTextState extends State<HotepReadMoreText> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    return widget.height != null && _showAll
        ? SizedBox(
            height: widget.height,
            child: SingleChildScrollView(
              child: _textBuilder(),
            ),
          )
        : _textBuilder();
  }

  Widget _textBuilder() {
    final _text = widget.text.length > widget.limit
        ? '${widget.text.substring(0, widget.limit)}...'
        : widget.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Linkify(
          text: _showAll ? widget.text : _text,
          style: widget.style,
          onOpen: (link) async {
            try {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              }
            } catch (e) {
              print(e);
              print('Error!!!: Opening link');
            }
          },
        ),
        SizedBox(
          height: 3.0,
        ),
        if (widget.text.length > widget.limit)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
            child: Text(
              _showAll ? 'Show Less' : 'Show More',
              style: widget.style == null
                  ? TextStyle(
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    )
                  : widget.showMoreTextStyle == null
                      ? widget.style?.copyWith(
                          color: blueColor,
                          fontWeight: FontWeight.bold,
                        )
                      : widget.showMoreTextStyle,
            ),
          )
      ],
    );
  }
}
