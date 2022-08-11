import 'package:flutter/material.dart';
import 'package:imhotep/widgets/stories_widgets/view_stories_item.dart';
import 'package:peaman/peaman.dart';

class ViewStoriesScreen extends StatefulWidget {
  final List<PeamanMoment> moments;
  final int initIndex;
  ViewStoriesScreen({
    required this.moments,
    required this.initIndex,
  });

  @override
  _ViewStoriesScreenState createState() => _ViewStoriesScreenState();
}

class _ViewStoriesScreenState extends State<ViewStoriesScreen>
    with SingleTickerProviderStateMixin {
  late PageController _scrollController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _index = widget.initIndex;
    });
    _scrollController = PageController(
      initialPage: widget.initIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: widget.moments.length,
                  itemBuilder: (context, index) {
                    final _moment = widget.moments[index];
                    return ViewStoriesItem(
                      moment: _moment,
                      onPageChanged: (val) => _changePage(val),
                    );
                  },
                  onPageChanged: (val) {
                    setState(() {
                      _index = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // change page when animation is completed
  _changePage(final bool val) {
    if (val) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.width * (_index + 1),
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );

      if (_index >= (widget.moments.length - 1) ||
          widget.initIndex >= (widget.moments.length - 1)) {
        Navigator.pop(context);
      }
    } else {
      if (_index >= 1) {
        _scrollController.animateTo(
          MediaQuery.of(context).size.width * (_index - 1),
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    }
  }
}
