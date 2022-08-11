import 'package:flutter/material.dart';
import 'package:peaman/peaman.dart';

enum _FetcherType {
  singleStream,
  multiStream,
}

class FeedFetcher extends StatelessWidget {
  final _FetcherType type;
  final Stream<PeamanFeed>? feedStream;
  final Stream<List<PeamanFeed>>? feedsStream;
  final Widget Function(PeamanFeed)? singleBuilder;
  final Widget Function(List<PeamanFeed>)? multiBuilder;

  const FeedFetcher.singleStream({
    Key? key,
    required this.feedStream,
    required this.singleBuilder,
  })  : type = _FetcherType.singleStream,
        feedsStream = null,
        multiBuilder = null,
        super(key: key);

  const FeedFetcher.multiStream({
    Key? key,
    required this.feedsStream,
    required this.multiBuilder,
  })  : type = _FetcherType.multiStream,
        feedStream = null,
        singleBuilder = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == _FetcherType.singleStream
        ? _singleStreamBuilder()
        : _multiStreamBuilder();
  }

  Widget _singleStreamBuilder() {
    return StreamBuilder<PeamanFeed>(
      stream: feedStream,
      builder: (context, snap) {
        if (snap.hasData) {
          final _user = snap.data!;
          return singleBuilder?.call(_user) ?? Container();
        }
        return Container();
      },
    );
  }

  Widget _multiStreamBuilder() {
    return StreamBuilder<List<PeamanFeed>>(
      stream: feedsStream,
      builder: (context, snap) {
        if (snap.hasData) {
          final _users = snap.data ?? [];
          return multiBuilder?.call(_users) ?? Container();
        }
        return Container();
      },
    );
  }
}
