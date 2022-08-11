import 'package:flutter/material.dart';
import 'package:peaman/peaman.dart';

enum _FetcherType {
  singleStream,
  multiStream,
  singleFuture,
  multiFuture,
}

class UserFetcher extends StatefulWidget {
  final _FetcherType type;
  final Stream<PeamanUser>? userStream;
  final Stream<List<PeamanUser>>? usersStream;
  final Future<PeamanUser>? userFuture;
  final Future<List<PeamanUser>>? usersFuture;
  final Widget Function(PeamanUser)? singleBuilder;
  final Widget Function(List<PeamanUser>)? multiBuilder;

  const UserFetcher.singleStream({
    Key? key,
    required this.userStream,
    required this.singleBuilder,
  })  : type = _FetcherType.singleStream,
        usersStream = null,
        multiBuilder = null,
        userFuture = null,
        usersFuture = null,
        super(key: key);

  const UserFetcher.multiStream({
    Key? key,
    required this.usersStream,
    required this.multiBuilder,
  })  : type = _FetcherType.multiStream,
        userStream = null,
        singleBuilder = null,
        userFuture = null,
        usersFuture = null,
        super(key: key);

  const UserFetcher.singleFuture({
    Key? key,
    required this.userFuture,
    required this.singleBuilder,
  })  : type = _FetcherType.singleFuture,
        userStream = null,
        usersStream = null,
        usersFuture = null,
        multiBuilder = null,
        super(key: key);

  const UserFetcher.multiFuture({
    Key? key,
    required this.usersFuture,
    required this.multiBuilder,
  })  : type = _FetcherType.multiFuture,
        userStream = null,
        usersStream = null,
        userFuture = null,
        singleBuilder = null,
        super(key: key);

  @override
  State<UserFetcher> createState() => _UserFetcherState();
}

class _UserFetcherState extends State<UserFetcher> {
  Stream<PeamanUser>? _userStream;
  Stream<List<PeamanUser>>? _usersStream;
  Future<PeamanUser>? _userFuture;
  Future<List<PeamanUser>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    _userStream = widget.userStream;
    _usersStream = widget.usersStream;
    _userFuture = widget.userFuture;
    _usersFuture = widget.usersFuture;
  }

  @override
  void didUpdateWidget(covariant UserFetcher oldWidget) {
    setState(() {
      _userStream = widget.userStream;
      _usersStream = widget.usersStream;
      _userFuture = widget.userFuture;
      _usersFuture = widget.usersFuture;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == _FetcherType.singleStream
        ? _singleStreamBuilder()
        : widget.type == _FetcherType.multiStream
            ? _multiStreamBuilder()
            : widget.type == _FetcherType.singleFuture
                ? _singleFutureBuilder()
                : _multiFutureBuilder();
  }

  Widget _singleStreamBuilder() {
    return StreamBuilder<PeamanUser>(
      stream: _userStream,
      builder: (context, snap) {
        if (snap.hasData) {
          final _user = snap.data!;
          return widget.singleBuilder?.call(_user) ?? Container();
        }
        return Container();
      },
    );
  }

  Widget _multiStreamBuilder() {
    return StreamBuilder<List<PeamanUser>>(
      stream: _usersStream,
      builder: (context, snap) {
        if (snap.hasData) {
          final _users = snap.data ?? [];
          return widget.multiBuilder?.call(_users) ?? Container();
        }
        return Container();
      },
    );
  }

  Widget _singleFutureBuilder() {
    return FutureBuilder<PeamanUser>(
      future: _userFuture,
      builder: (context, snap) {
        if (snap.hasData) {
          final _user = snap.data!;
          return widget.singleBuilder?.call(_user) ?? Container();
        }
        return Container();
      },
    );
  }

  Widget _multiFutureBuilder() {
    return FutureBuilder<List<PeamanUser>>(
      future: _usersFuture,
      builder: (context, snap) {
        if (snap.hasData) {
          final _users = snap.data ?? [];
          return widget.multiBuilder?.call(_users) ?? Container();
        }
        return Container();
      },
    );
  }
}
