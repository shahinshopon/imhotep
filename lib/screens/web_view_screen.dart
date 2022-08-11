import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final FutureOr<NavigationDecision> Function(NavigationRequest)?
      navigationDelegate;
  const WebViewScreen({
    required this.url,
    this.navigationDelegate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            return navigationDelegate?.call(request) ??
                NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
